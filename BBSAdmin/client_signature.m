#include "client_signature.h"

/****
 sample for client_signature.h, see http://wiki.open.newsmth.net
 #define CLIENT_SIGNATURE @"111111111111111"
 #define CLIENT_SECRET @"111111111111111"
 #define CLIENT_USERID @"xxxx"
 ****/

NSString * client_get_signature()
{
    return CLIENT_SIGNATURE;
}

NSString * client_get_secret()
{
    return CLIENT_SECRET;
}

NSString * client_get_userid()
{
    return CLIENT_USERID;
}