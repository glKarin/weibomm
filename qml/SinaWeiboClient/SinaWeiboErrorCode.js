function getErrorInfo(error_code)
{
    var res = "";

    if(( (200 != error_code) && (1<=error_code)&&(error_code <= 302))
        || (399 == error_code))
    {
        res = "网络异常，请重试！";
        return res;
    }

    switch(error_code)
    {
    case 200:
        {
            res = "执行成功!";
            break;
        }
    case 304 :
        {
            //res = "没有数据返回.";
            res = "服务器错误，请重试！";
            break;
        }
    case 40028:
        {
            //res = "内部接口错误(如果有详细的错误信息，会给出更为详细的错误提示)";
            res = "服务器错误，请重试！";
            break;
        }
    case 40033:
        {
            //res = "source_user或者target_user用户不存在";
            res = "服务器错误，请重试！";
            break;
        }
    case 40031:
        {
            res = "此微博不存在";
            break;
        }
    case 40036:
        {
            res = "此微博不是当前用户发布的微博";
            break;
        }
    case 40034:
        {
            res = "不能转发自己的微博";
            break;
        }
    case 40038:
        {
            res = "不合法的微博";
            break;
        }
    case 40037:
        {
            res = "不合法的评论";
            break;
        }
    case 40015:
        {
            res = "该条评论不是当前登录用户发布的评论";
            break;
        }
    case 40017:
        {
            res = "不能给不是你粉丝的人发私信";
            break;
        }
    case 40019:
        {
            res = "不合法的私信";
            break;
        }
    case 40021:
        {
            res = "不是属于你的私信";
            break;
        }
    case 40022:
        {
            //res = "source参数(appkey)缺失";
            res = "服务器错误，请重试！";
            break;
        }
    case 40007:
        {
            //res = "格式不支持，仅仅支持XML或JSON格式";
            res = "服务器错误，请重试！";
            break;
        }
    case 40009:
        {
            //res = "图片错误，请确保使用multipart上传了图片";
            res = "服务器错误，请重试！";
            break;
        }
    case 40011:
        {
            res = "私信发布超过上限";
            break;
        }
    case 40012:
        {
            res = "内容为空";
            break;
        }
    case 40016:
        {
            //res = "微博id为空";
            res = "服务器错误，请重试！";
            break;
        }
    case 40018:
        {
            //res = "ids参数为空";
            res = "服务器错误，请重试！";
            break;
        }
    case 40020:
        {
            //res = "评论ID为空";
            res = "服务器错误，请重试！";
            break;
        }
    case 40023:
        {
            res = "用户不存在";
            break;
        }
    case 40024:
        {
            //res = "ids过多，请参考API文档";
            res = "服务器错误，请重试！";
            break;
        }
    case 40025:
        {
            res = "不能发布相同的内容";
            break;
        }
    case 40026:
        {
            res = "用户名不正确！";
            break;
        }
    case 40045:
        {
            res = "不支持的图片类型,支持的图片类型有JPG,GIF,PNG";
            break;
        }
    case 40008:
        {
            res = "图片大小错误，上传的图片大小上限为5M";
            break;
        }
    case 40001:
        {
            //res = "参数错误，请参考API文档";
            res = "服务器错误，请重试！";
            break;
        }
    case 40002:
        {
            //res = "不是对象所属者，没有操作权限";
            res = "服务器错误，请重试！";
            break;
        }
    case 40010:
        {
            res = "私信不存在";
            break;
        }
    case 40013:
        {
            res = "微博太长，请确认不超过140个字符";
            break;
        }
    case 40039:
        {
            //res = "地理信息输入错误";
            res = "服务器错误，请重试！";
            break;
        }
    case 40040:
        {
            //res = "IP限制，不能请求该资源";
            res = "服务器错误，请重试！";
            break;
        }
    case 40041:
        {
            //res = "uid参数为空";
            res = "服务器错误，请重试！";
            break;
        }
    case 40042:
        {
            //res = "token参数为空";
            res = "服务器错误，请重试！";
            break;
        }
    case 40043:
        {
            //res = "domain参数错误";
            res = "服务器错误，请重试！";
            break;
        }
    case 40044:
        {
            //res = "appkey参数缺失";
            res = "服务器错误，请重试！";
            break;
        }
    case 40029:
        {
            //res = "verifier错误";
            res = "服务器错误，请重试！";
            break;
        }
    case 40027:
        {
            //res = "标签参数为空";
            res = "服务器错误，请重试！";
            break;
        }
    case 40032:
        {
            res = "列表名太长，请确保输入的文本不超过10个字符";
            break;
        }
    case 40030:
        {
            res = "列表描述太长，请确保输入的文本不超过70个字符";
            break;
        }
    case 40035:
        {
            //res = "列表不存在";
            res = "服务器错误，请重试！";
            break;
        }
    case 40053:
        {
            //res = "权限不足，只有创建者有相关权限";
            res = "服务器错误，请重试！";
            break;
        }
    case 40054:
        {
            //res = "参数错误，请参考API文档";
            res = "服务器错误，请重试！";
            break;
        }
    case 401 :
        {
            //res = "没有进行身份验证.";
            res = "服务器错误，请重试！";
            break;
        }
    case 402 :
        {
            res = "没有开通微博";
            break;
        }
    case 403 :
        {
            //res = "没有权限访问对应的资源.";
            res = "服务器错误，请重试！";
            break;
        }
    case 404 :
        {
            //res = "请求的资源不存在.";
            res = "服务器错误，请重试！";
            break;
        }
    case 500 :
        {
            //res = "服务器内部错误.";
            res = "服务器错误，请重试！";
            break;
        }
    case 502 :
        {
            //res = "微博接口API关闭或正在升级.";
            res = "服务器错误，请重试！";
            break;
        }
    case 503 :
        {
            //res = "服务端资源不可用.";
            res = "服务器错误，请重试！";
            break;
        }
    default:
        //res = "未知错误.";
        res = "服务器错误，请重试！";
        break;
    }

    return res;
}
