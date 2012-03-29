#ifndef __LYCCMETROMENU_H
#define __LYCCMETROMENU_H

#include <String.h>
#include "cocos2d.h"

using namespace cocos2d;

class LYCCMetroItem: public CCLayer
{
public:
	virtual bool init();  
	virtual void update(ccTime dt);
	static cocos2d::CCScene* scene();
	LAYER_NODE_FUNC(LYCCMetroMenu);

	float weight;

	float counter;
};

class LYCCMetroMenu: public CCLayer
{
public:
	virtual bool init();  
	virtual void update(ccTime dt);
	static cocos2d::CCScene* scene();
	LAYER_NODE_FUNC(LYCCMetroMenu);

	float counter;
};

#endif	//	__LYCCMETROMENU_H
