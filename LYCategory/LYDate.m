#import "LYDate.h"

@implementation NSDate (LYDate)
- (BOOL)is_same_month:(NSDate*)date1
{
	NSCalendar* calendar = [NSCalendar currentCalendar];

	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
	NSDateComponents* comp2 = [calendar components:unitFlags fromDate:self];

	return [comp1 month] == [comp2 month] && [comp1 year] == [comp2 year];
}
- (BOOL)is_same_date:(NSDate*)date1
{
	NSCalendar* calendar = [NSCalendar currentCalendar];

	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
	NSDateComponents* comp2 = [calendar components:unitFlags fromDate:self];

	return [comp1 day] == [comp2 day] &&
		[comp1 month] == [comp2 month] &&
		[comp1 year]  == [comp2 year];
}
@end
