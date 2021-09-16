//
//  NSBundle+ChatCore.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/07/2017.
//
//

#import "NSBundle+Core.h"
#import <ChatSDK/Core.h>

#define bLocalizableFile @"ChatSDKLocalizable"

@implementation NSBundle(Core)

+(NSBundle *) coreBundle {
    return [NSBundle bundleWithName:bCoreBundleName];
}

+(NSString *) localizationFileForLang:(NSString *)lang name: (NSString *) name bundle: (NSBundle *) bundle {
    NSString * filename = [[name stringByAppendingString:@"."] stringByAppendingString:lang];
    if ([bundle pathForResource:filename ofType:@"strings"]) {
        return filename;
    }
    return nil;
}

+(NSString *) bestLocalizationFileForLang:(NSString *) lang name: (NSString *) name bundle: (NSBundle *) bundle {
    NSString * exact = [self localizationFileForLang:lang name:name bundle:bundle];
    if (exact) return exact;
    lang = [[lang componentsSeparatedByString:@"-"] firstObject];
    NSString * general = [self localizationFileForLang:lang name:name bundle:bundle];
    if (general) return general;
    return name;
}

+(NSString *) textForKey:(NSString *) key bundle: (NSBundle *) bundle fallbackBundle: (NSBundle *) fallbackBundle localizable: (NSString *) localizable {
    NSString * localized = [self localizedTextForKey:key bundle:bundle localizable:localizable];
    if (![localized isEqualToString:key])
        return localized;
    localized = [self localizedTextForKey:key bundle:fallbackBundle localizable:localizable];
    if (![localized isEqualToString:key])
        return localized;
    localized = [self defaultTextForKey:key bundle:bundle localizable:localizable];
    if (![localized isEqualToString:key])
        return localized;
    return [self defaultTextForKey:key bundle:fallbackBundle localizable:localizable];
}

+(NSString *) localizedTextForKey:(NSString *) key bundle: (NSBundle *) bundle localizable: (NSString *) localizable {
    NSString * lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString * localizableFile = [self bestLocalizationFileForLang:lang name:localizable bundle:bundle];
    if (!localizableFile) return key;
    return NSLocalizedStringFromTableInBundle(key, localizableFile, bundle, @"");
}

+(NSString *) defaultTextForKey:(NSString *) key bundle: (NSBundle *) bundle localizable: (NSString *) localizable {
    return NSLocalizedStringFromTableInBundle(key, localizable, bundle, @"");
}

+(NSString *) t:(NSString *) string {
    return [self textForKey:string bundle:[NSBundle mainBundle] fallbackBundle:[self coreBundle] localizable:bLocalizableFile];
}

+(NSString *) textForMessage: (id<PMessage>) message {
    NSString * text;
    if (message.isReply) {
        text = message.reply;
    }
    else if (message.type.intValue == bMessageTypeImage) {
        text = [self t:bImageMessage];
    }
    else if(message.type.intValue == bMessageTypeLocation) {
        text = [self t:bLocationMessage];
    }
    else if(message.type.intValue == bMessageTypeAudio) {
        text = [self t:bAudioMessage];
    }
    else if(message.type.intValue == bMessageTypeVideo) {
        text = [self t:bVideoMessage];
    }
    else if(message.type.intValue == bMessageTypeSticker) {
        text = [self t:bStickerMessage];
    }
    else if(message.type.intValue == bMessageTypeFile) {
        text = [self t:bFileMessage];
    }
    else {
        text = message.text;
    }
    return text;
}

@end
