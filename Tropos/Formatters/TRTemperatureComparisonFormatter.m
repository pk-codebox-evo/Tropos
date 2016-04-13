#import "Tropos-Swift.h"
#import "TRTemperatureComparisonFormatter.h"

typedef NS_ENUM(NSUInteger, TRTimeOfDay) {
    TRTimeOfDayMorning,
    TRTimeOfDayDay,
    TRTimeOfDayAfternoon,
    TRTimeOfDayNight
};

@implementation TRTemperatureComparisonFormatter

+ (NSString *)localizedStringFromComparison:(TRTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective precipitation:(NSString *)precipitation date:(NSDate *)date
{
    NSString *formatString = (comparison == TRTemperatureComparisonSame)? NSLocalizedString(@"SameTemperatureFormat", nil) : NSLocalizedString(@"DifferentTemperatureFormat", nil);
    *adjective = [self localizedAdjectiveForTemperatureComparison:comparison];

    return [NSString stringWithFormat:formatString, *adjective, [self localizedCurrentTimeOfDayForDate:date], [self localizedPreviousTimeOfDayForDate:date], precipitation];
}

#pragma mark - Private Methods

+ (NSString *)localizedAdjectiveForTemperatureComparison:(TRTemperatureComparison)comparison
{
    switch (comparison) {
        case TRTemperatureComparisonHotter:
            return NSLocalizedString(@"Hotter", nil);
        case TRTemperatureComparisonWarmer:
            return NSLocalizedString(@"Warmer", nil);
        case TRTemperatureComparisonCooler:
            return NSLocalizedString(@"Cooler", nil);
        case TRTemperatureComparisonColder:
            return NSLocalizedString(@"Colder", nil);
        case TRTemperatureComparisonSame:
            return NSLocalizedString(@"Same", nil);
    }
}

+ (NSString *)localizedCurrentTimeOfDayForDate:(NSDate *)date
{
    switch ([self timeOfDayForDate:date]) {
        case TRTimeOfDayNight:
            return NSLocalizedString(@"Tonight", nil);
        case TRTimeOfDayMorning:
            return NSLocalizedString(@"ThisMorning", nil);
        case TRTimeOfDayDay:
            return NSLocalizedString(@"Today", nil);
        case TRTimeOfDayAfternoon:
            return NSLocalizedString(@"ThisAfternoon", nil);
        default:
            break;
    }
}

+ (NSString *)localizedPreviousTimeOfDayForDate:(NSDate *)date
{
    switch ([self timeOfDayForDate:date]) {
        case TRTimeOfDayNight:
            return NSLocalizedString(@"LastNight", nil);
        case TRTimeOfDayMorning:
            return NSLocalizedString(@"YesterdayMorning", nil);
        case TRTimeOfDayDay:
            return NSLocalizedString(@"Yesterday", nil);
        case TRTimeOfDayAfternoon:
            return NSLocalizedString(@"YesterdayAfternoon", nil);
        default:
            break;
    }
}

+ (TRTimeOfDay)timeOfDayForDate:(NSDate *)date;
{
    NSDateComponents *dateComponents = [[self calendar] components:NSCalendarUnitHour fromDate:date];

    if (dateComponents.hour < 4) {
        return TRTimeOfDayNight;
    } else if (dateComponents.hour < 9) {
        return TRTimeOfDayMorning;
    } else if (dateComponents.hour < 14) {
        return TRTimeOfDayDay;
    } else if (dateComponents.hour < 17) {
        return TRTimeOfDayAfternoon;
    } else {
        return TRTimeOfDayNight;
    }
}

+ (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

@end
