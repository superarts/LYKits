#include "LYCCMetroMenu.h"

#if 0
#define count			4
#define interval_frame	0.25

bool LYCCMetroMenu::init()
{
	if (!CCLayer::init())
	{
		return false;
	}
	counter = 0;
	schedule(schedule_selector(LYCCMetroMenu::update));
	return true;
}

void LYCCMetroMenu::update(ccTime dt)
{
	//	CCLog("%.02f, %.02f", counter, dt);
	counter += dt;
	if (counter < interval_frame)
	{
		glPointSize(1);
	}
}
#endif

/*
 * test
 */
CCScene* MainMenu::scene()
{
	CCScene *scene = CCScene::node();

	MainMenu *layer = MainMenu::node();
	scene->addChild(layer);

	return scene;
}

bool MainMenu::init()
{
	if ( !CCLayer::init() )
	//	if (CCLayerColor::initWithColor(ccc4(0,20,0,255)))
	{
		return false;
	}

	CCSize size = CCDirector::sharedDirector()->getWinSize();
#if 0
    CCLabelTTF* label_title = CCLabelTTF::labelWithString("燃烧的宇宙", "Arial", 64);
	label_title->setPosition(ccp(size.width / 2, size.height - 112));
	this->addChild(label_title);

	CCActionInterval* color_action = CCTintBy::actionWithDuration(0.5f, 0, -255, -255);
	CCActionInterval* color_back = color_action->reverse();
	CCFiniteTimeAction* seq = CCSequence::actions(color_action, color_back, NULL);
	label_title->runAction(CCRepeatForever::actionWithAction((CCActionInterval*)seq));
#endif

	CCMenuItemFont::setFontSize(28);
	//	menu
    //	CCMutableArray<CCObject*>* array = new CCMutableArray<CCObject*>();
	LYCCMetroMenu* menu = LYCCMetroMenu::menu();
	//CCMenu*	menu;
	//menu = CCMenu::init();
	for (int i = 0; i < 9; i++)
	{
		stringstream ss;
		ss << "Item " << i;
		LYCCMetroItem* item = LYCCMetroItem::itemFromString(ss.str().c_str(), this, menu_selector(MainMenu::onTest), 
				i, i);
#if 0
		if (i == 0)
			menu = CCMenu::menuWithItem(item);
			//menu = LYCCMetroMenu::menuWithItem(item);
		else
#endif
			menu->addChild(item, 0, i);
	}
#if 0
	CCMenuItemFont* item1	= CCMenuItemFont::itemFromString("Item 1", this, menu_selector(MainMenu::onTest));
	CCMenuItemFont* item2	= CCMenuItemFont::itemFromString("Item 2", this, menu_selector(MainMenu::onTest));
	CCMenuItemFont* item3	= CCMenuItemFont::itemFromString("Item 3", this, menu_selector(MainMenu::onTest));
	CCMenuItemFont* item4	= CCMenuItemFont::itemFromString("Item 4", this, menu_selector(MainMenu::onTest));
#endif

	//CCMenu* menu = CCMenu::menuWithItems(item1, item2, item3, item4, NULL);
	//menu->alignItemsVertically();
	//menu->alignItemsInColumns(3, 3, 3);
	//menu->setPosition(ccp(240, 260));
	menu->refresh();
	menu->setPosition(ccp(size.width/2, size.height/2));
	menu->setColor(ccc3(255, 0, 0));

	addChild(menu);

	return true;
}

void MainMenu::onTest(CCObject* pSender)
{
	printf("on test\n");
}

void MainMenu::onQuit(CCObject* pSender)
{
	CCDirector::sharedDirector()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
	exit(0);
#endif
}
