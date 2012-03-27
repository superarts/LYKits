#ifndef __LYCOCOS2D_H
#define __LYCOCOS2D_H

#include "cocos2d.h"

USING_NS_CC;


#define K_LYCC_STR_MAX		1024
#define k_lycc_tag_main		0
#define lycc_set_stage_layer_scene(a_type, a_layer, a_scene)	CCScene* a_scene = a_type::scene(); \
	a_type* a_layer = (a_type*)a_scene->getChildByTag(k_lycc_tag_main);
#define lycc_scene_func(class)	static CCScene* scene() \
{ \
	CCScene* scene = CCScene::node(); \
	LYCCStage* layer = class::node(); \
	scene->addChild(layer, 0, k_lycc_tag_main); \
	return scene; \
}
#define lycc_functions(class)	LAYER_NODE_FUNC(class); \
	lycc_scene_func(class)

/*
 * controller
 */

class LYCCDelegate
{
public:
	virtual void callback() {};
};

class LYCCController
{
public:
	static LYCCController* controller()
	{
		if (!instance)
		{
			instance = new LYCCController;
			instance->current_level = -1;
			instance->has_passed = false;
			instance->last_stage = "init";
		}
		return instance;
	};

	int current_level;
	bool has_passed;
	string last_stage;
	LYCCDelegate* delegate;

private:
	LYCCController() {};
	LYCCController(LYCCController const&) {};
	LYCCController& operator=(LYCCController const&) {};
	static LYCCController* instance;
};

#define lycc					LYCCController::controller()
#define lycc_callback			lycc->delegate->callback();
#define lycc_delegate(class, d)	class* d = (class*)lycc->delegate;

class LYCCStage: public CCLayer
{
public:
	virtual bool init()
	{
		//	if (CCLayerColor::initWithColor(ccc4(0,20,0,255)))
		if (!CCLayer::init())
			return false;
		setIsTouchEnabled(true);
		return true;
	};
	lycc_functions(LYCCStage)
};

class LYCCStageGame: public LYCCStage
{
public:
	virtual bool init()
	{
		if (!LYCCStage::init())
		{
			return false;
		}

		return true;
	};
	lycc_functions(LYCCStageGame)
};

/*
 * display a label in the middle of the screen
 */

class LYCCStageLabel: public LYCCStage
{
public:
    CCLabelTTF* label_main;

	virtual bool init()
	{
		if (!LYCCStage::init())
		{
			return false;
		}

		label_main = CCLabelTTF::labelWithString("Tap the screen to continue...", "Arial", 32);
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		label_main->setPosition(ccp(size.width / 2, size.height / 2));
		addChild(label_main);

		return true;
	};
	virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent)
	{
		lycc->has_passed = true;
		lycc->last_stage = "label";
		lycc_callback;
	};
	lycc_functions(LYCCStageLabel)
};

/*
 * display "level x"
 */

class LYCCStageSplash: public LYCCStage
{
public:
    CCLabelTTF* label_main;
	string format;
	float timeout;
	float counter;

	virtual bool init()
	{
		if (!LYCCStage::init())
		{
			return false;
		}

		format = "Level %i";
		timeout = 1;
		counter = 0;
		label_main = CCLabelTTF::labelWithString("Start!", "Arial", 32);
		schedule(schedule_selector(LYCCStageSplash::update)); 

		return true;
	};
	virtual void onEnter()
	{
		CCLayer::onEnter();
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		label_main->setPosition(ccp(size.width / 2, size.height / 2));
		addChild(label_main);

		char s[K_LYCC_STR_MAX];
		sprintf(s, format.c_str(), lycc->current_level);
		label_main->setString(s);
	}
	void update(ccTime dt)
	{
		counter += dt;
		//	CCLog("%.01f, %.01f", counter, timeout);
		if (counter > timeout)
		{
			lycc->last_stage = "splash";
			lycc_callback;
		}
	};
	lycc_functions(LYCCStageSplash)
};

class LYCCStageStory: public LYCCStage
{
public:
    CCLabelTTF* label_main;
	float timeout;
	float counter;
	vector<string> script;
	int	index;

	virtual bool init()
	{
		if (!LYCCStage::init())
		{
			return false;
		}

		timeout = 10;
		label_main = CCLabelTTF::labelWithString("Start!", "Arial", 32);
		schedule(schedule_selector(LYCCStageStory::update)); 

		return true;
	};
	virtual void onEnter()
	{
		counter = 0;
		CCLayer::onEnter();
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		label_main->setPosition(ccp(size.width / 2, size.height / 2));
		addChild(label_main);
		index = 0;
		string s = script.at(index);
		label_main->setString(s.c_str());
	}
	void update(ccTime dt)
	{
		counter += dt;
		if (counter > timeout)
		{
			lycc->last_stage = "story";
			ccTouchesEnded(NULL, NULL);
		}
	}
	virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent)
	{
		index++;
		if (index < script.size())
		{
			counter = 0;
			string s = script.at(index);
			label_main->setString(s.c_str());
		}
		else
		{
			lycc->last_stage = "story";
			lycc_callback;
		}
	};
	lycc_functions(LYCCStageStory)
};

/*
 * game demo
 */

class LYCCGameDemo: public LYCCStageGame
{
public:
    CCLabelTTF* label;
	virtual bool init()
	{
		if (!LYCCStageGame::init())
		{
			return false;
		}

		label = CCLabelTTF::labelWithString("Game Demo", "Arial", 32);
		CCSize size = CCDirector::sharedDirector()->getWinSize();
		label->setPosition(ccp(size.width / 2, size.height / 2));
		addChild(label);

		return true;
	};
	virtual void onEnter()
	{
		CCLayer::onEnter();

		char s[64];
		sprintf(s, "Game Demo\nLevel: %i", lycc->current_level);
		label->setString(s);
	};
	virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent)
	{
		lycc->has_passed = false;
		lycc->last_stage = "demo";
		lycc_callback;
	};
	lycc_functions(LYCCGameDemo)
};

#endif
