#ifndef __LYCCMETROMENU_H
#define __LYCCMETROMENU_H

#include <String.h>
#include <sstream>
#include "cocos2d.h"

using namespace cocos2d;

class LYCCMetroItem: public CCMenuItemFont
{
public:
	//virtual bool init();  
	//virtual void update(ccTime dt);
	//LAYER_NODE_FUNC(LYCCMetroItem);

	float weight;
	float counter;

	static LYCCMetroItem* itemFromString(const char *value, SelectorProtocol* target, SEL_MenuHandler selector)
	{
		LYCCMetroItem* item = new LYCCMetroItem();
		item->initFromString(value, target, selector);
		item->autorelease();

		CCLayerColor* layer = CCLayerColor::layerWithColorWidthHeight(ccc4(0x00, 0xFF, 0x00, 0xFF), 
		//		item->boundingBox().size.width, 
		//		item->boundingBox().size.height);
				item->getContentSize().width, 
				item->getContentSize().height);
		item->addChild(layer, -1);

		CCLabelTTF* label_title = CCLabelTTF::labelWithString("test", "Arial", 16);
		//CCSize size = CCDirector::sharedDirector()->getWinSize();
		//label_title->setPosition(ccp(size.width / 2, size.height - 112));
		item->addChild(label_title, 1);

		return item;
	}
#if 0
	bool initFromString(const char *value, SelectorProtocol* target, SEL_MenuHandler selector)
	{
		//	CCAssert( value != NULL && strlen(value) != 0, "Value length must be greater than 0");
		if (CCMenuItemFont::itemFromString(value, target, selector))
		{
		}
		return true;
	}
#endif
};

class LYCCMetroMenu: public CCMenu
{
public:
#if 0
	virtual bool init();  
	virtual void update(ccTime dt);
	static cocos2d::CCScene* scene();
	LAYER_NODE_FUNC(LYCCMetroMenu);

	float counter;
#endif
#if 1
	static LYCCMetroMenu* menu()
	{
		//return CCMenu::menuWithItem(item);
#if 1
		LYCCMetroMenu* menu = new LYCCMetroMenu();
		menu->init();
		menu->autorelease();

		return menu;
#endif
	}
	void refresh()
	{
		alignItemsVertically();
	}
#endif
};

class MainMenu: public cocos2d::CCLayerColor
{
public:
	virtual bool init();  
	//virtual void update(ccTime dt);
	//virtual void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent);
	static cocos2d::CCScene* scene();
	void onQuit(CCObject* pSender);
	void onTest(CCObject* pSender);
	LAYER_NODE_FUNC(MainMenu);
};

#endif	//	__LYCCMETROMENU_H
