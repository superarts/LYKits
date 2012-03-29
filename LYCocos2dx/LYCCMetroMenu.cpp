#include "LYCCMetroMenu.h"

#define count			4
#define interval_frame	0.25

CCScene* LYCCMetroMenu::scene()
{
	CCScene *scene = CCScene::node();
	LYCCMetroMenu *layer = LYCCMetroMenu::node();
	scene->addChild(layer);
	return scene;
}

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
