<%@ WebHandler Language="C#" Class="anbiao_bg" %>

using System;
using System.Data;
using System.Linq;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;
using Aspose.Words;
using Aspose.Words.Tables;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Reflection;
using System.Globalization; ///To use CultureInfo
using System.Threading;
using System.Threading.Tasks;
using ICSharpCode.SharpZipLib;

public class anbiao_bg : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";
        string temp = "Hello World";

        string type = context.Request["type"];
        if ("upload" == type)//分页条
        {
            temp = upload_Files(context);
        }
        else        if ("edit" == type)//分页条
        {
            temp = edit(context);
        }
        else        if ("getBaoGao" == type)//分页条
        {
            temp = getBaoGao(context);
        }
        else        if ("updateBaoGao" == type)//分页条
        {
            temp = updateBaoGao(context);
        }
        else        if ("shengchengPSBaoGao" == type)//分页条
        {
            temp = shengchengPSBaoGao(context);
        }

        else        if ("pingshenBaogao" == type)//分页条
        {
            temp = pingshenBaogao(context);
        }
        else        if ("getRenwu" == type)//分页条
        {
            temp = getRenwu(context);
        }  else        if ("delete" == type)//分页条
        {
            temp = delete(context);
        } else        if ("getRenwuAll" == type)//分页条
        {
            temp = getRenwuAll(context);
        }
        else        if ("getDanWeiRenYuan" == type)//分页条
        {
            temp = getDanWeiRenYuan(context);
        }
        else        if ("editDanWeiRenYuan" == type)//分页条
        {
            temp = editDanWeiRenYuan(context);
        }
        else  if ("deleteDanWeiRenYuan" == type)//分页条
        {
            temp = deleteDanWeiRenYuan(context);
        }
        else  if ("getRenWuDetail" == type)//分页条
        {
            temp = getRenWuDetail(context);
        }
        else  if ("shengchengBaogao" == type)//分页条
        {
            temp = shengchengBaogao(context);
        }        else  if ("saveRenWuDetail" == type)//分页条
        {
            temp = saveRenWuDetail(context);
        }
        else        if ("editDanWeiSheBei" == type)//分页条
        {
            temp = editDanWeiSheBei(context);
        }
        else  if ("deleteDanWeiSheBei" == type)//分页条
        {
            temp = deleteDanWeiSheBei(context);
        }
        else  if ("getDanWeiSheBei" == type)//分页条
        {
            temp = getDanWeiSheBei(context);
        }        else  if ("updateDanWeiXiangQing" == type)//分页条
        {
            temp = updateDanWeiXiangQing(context);
        }
        else  if ("getDanWeiXiangQing" == type)//分页条
        {
            temp = getDanWeiXiangQing(context);
        }        else  if ("updateBuHeGe" == type)//分页条
        {
            temp = updateBuHeGe(context);
        }     else  if ("getBuHeGe" == type)//分页条
        {
            temp = getBuHeGe(context);
        }     else  if ("baogaoBuhege" == type)//分页条
        {
            temp = baogaoBuhege(context);
        }
        else  if ("uploadImage" == type)//分页条
        {
            temp = uploadImage(context);
        }  else  if ("updateImage" == type)//分页条
        {
            temp = updateImage(context);
        } else  if ("getImage" == type)//分页条
        {
            temp = getImage(context);
        }else  if ("deleteImage" == type)//分页条
        {
            temp = deleteImage(context);
        }         else  if ("docTodocx" == type)//分页条
        {
            temp = docTodocx(context);
        }       else  if ("downLoadZipFiles" == type)//分页条
        {
            temp = downLoadZipFiles(context);
        }    else  if ("readFiles" == type)//分页条
        {
            temp = readFiles(context);
        }



        //else
        //    temp = converTojson(context);

        context.Response.Write(temp);
    }

    public class PICSDETAIL {
        public string PIC_PS_ID {get;set;}
        public string PIC_Type {get;set;}
        public object[] PIC_Urls{get;set;}
    }
    public class ImgUrls{
        public  string PIC_ID{get;set;}
        public  string PIC_Name{get;set;}
        public  string PIC_Type{get;set;}
        public  string PIC_Url{get;set;}
    }
    public string deleteImage(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd();
        PICSDETAIL _tempDetail = JsonConvert.DeserializeObject<PICSDETAIL>(json);//反序列化;
        string jso = "图片信息修改成功！";
        string _PS_ID = _tempDetail.PIC_PS_ID;
        string _PS_Type= _tempDetail.PIC_Type;
        StringBuilder querySelectSql = new StringBuilder("delete from   [AnBiaoPics]    where PIC_PS_ID ='"+_PS_ID+"' and PIC_Type='"+_PS_Type+"' ");
        StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoPics]    where PIC_PS_ID ='"+_PS_ID+"' and PIC_Type='"+_PS_Type+"' ");
        int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));

        string jsonString = "删除成功！" ;

        if (SqlCount == 0)
        {
            jsonString = "查无此数据"+_PS_ID+"|"+_PS_Type;
        }
        else
        {
            IDataReader reader = Class1.GetDataReader(querySelectSql.ToString());

        }
        return jsonString.ToString();
    }
    public string getImage(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd();
        PICSDETAIL _tempDetail = JsonConvert.DeserializeObject<PICSDETAIL>(json);//反序列化;
        string jso = "图片信息修改成功！";
        string _PS_ID = _tempDetail.PIC_PS_ID;
        string _PS_Type= _tempDetail.PIC_Type;
        StringBuilder querySelectSql = new StringBuilder("select PIC_Urls from   [AnBiaoPics]    where PIC_PS_ID ='"+_PS_ID+"' and PIC_Type='"+_PS_Type+"' ");
        StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoPics]    where PIC_PS_ID ='"+_PS_ID+"' and PIC_Type='"+_PS_Type+"' ");
        int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));
        IDataReader reader = Class1.GetDataReader(querySelectSql.ToString());

        StringBuilder jsonString = new StringBuilder("");
        jsonString.Append("{\"count\":"+SqlCount);
        jsonString.Append(",\"Data\":");
        if (SqlCount == 0)
        {
            jsonString.Append("\"\"}");
            jso = jsonString.ToString();
        }
        else
        {
            while (reader.Read())
            {
                if (reader["PIC_Urls"].ToString() == "")
                    jsonString.Append("\"\"");
                else
                {
                    jsonString.Append(reader["PIC_Urls"].ToString());

                }
            }
            jsonString.Append("}");

        }
        return jsonString.ToString();
    }
    public string updateImage(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Trim();
        // json = json.Substring(0, json.Length - 1);
        PICSDETAIL _tempDetail = JsonConvert.DeserializeObject<PICSDETAIL>(json);//反序列化;
        string jso = "图片信息修改成功！";
        string _PS_ID = _tempDetail.PIC_PS_ID;
        var _TYPE = _tempDetail.PIC_Type;
        string _URLS =JsonConvert.SerializeObject( _tempDetail.PIC_Urls);

        if (_PS_ID != "")
        {

            string timeNow = DateTime.Now.ToString("yyyyMMddHHmmss");
            StringBuilder _UPDATE_SQL = new StringBuilder("update [AnBiaoPics] set ");
            _UPDATE_SQL.Append("PIC_EditTime ='" + timeNow + "',");
            if (_tempDetail != null)
            {
                if (!string.IsNullOrEmpty(_PS_ID)) { _UPDATE_SQL.Append("PIC_PS_ID='" + _PS_ID + "',"); }
                if (!string.IsNullOrEmpty(_TYPE)) { _UPDATE_SQL.Append("PIC_Type='" + _TYPE + "',"); }
                if (!string.IsNullOrEmpty(_URLS)) { _UPDATE_SQL.Append("PIC_Urls='" + _URLS + "'  "); }
                _UPDATE_SQL.Remove(_UPDATE_SQL.Length - 1, 1);
                _UPDATE_SQL.Append("where PIC_PS_ID ='" + _PS_ID + "' and PIC_Type ='"+_TYPE+"'");


                string _SELECT_SQL = "select count(*) from [AnBiaoPics] where PIC_PS_ID ='" + _PS_ID + "' and PIC_Type='" + _TYPE + "'";
                int _SelectCount = Convert.ToInt16(Class1.GetSqlResult(_SELECT_SQL));
                if (_SelectCount == 0)
                {
                    string _INSERST_SQL = @"insert into AnBiaoPics([PIC_PS_ID]
      ,[PIC_Type]
      ,[PIC_Urls]     
      ,[PIC_AddTime]) values('" + _PS_ID + "','" +
        _TYPE + "','" +
        _URLS + "','" +
    timeNow + "')";
                    int _InsertCount = Convert.ToInt16(Class1.ExecCommand(_INSERST_SQL));

                    if (_InsertCount > 0)
                    {
                        jso = "{msg:'添加成功！'}";
                    }
                    else
                        jso = "{msg:'添加失败！'}";

                }
                else
                {

                    /*string _picurls="";
					_SELECT_SQL = "select PIC_Urls from [AnBiaoPics] where PIC_PS_ID ='" + _PS_ID + "' and PIC_Type='" + _TYPE + "'";
				    IDataReader reader = Class1.GetDataReader(_SELECT_SQL.ToString());
					while (reader.Read())
					{
					_picurls=reader["PIC_Urls"].ToString();
					
					}*/
                    string _tt = Class1.GetSqlResult(_UPDATE_SQL.ToString());
                    List<ImgUrls> objImge =  JsonConvert.DeserializeObject<List<ImgUrls>>(_URLS)  as List<ImgUrls>;;
                    string path =saveFilePath+"\\"+_PS_ID+"\\"+_TYPE;
                    string _name ="";
                    string _temp="";

                    // return objImge.Count+"";
                    List<string> _baoliu=new List<string>();
                    if(objImge.Count>0)
                        foreach (var name in objImge)
                        {
                            _baoliu.Add(name.PIC_Url.Substring(name.PIC_Url.LastIndexOf("/")+1));
                        }
                    List<string> _files = listDirectory(path);
                    IEnumerable<string> exceptLs =_files.Except(_baoliu);

                    foreach (string item in exceptLs)
                    {
                        if(File.Exists(path+"\\"+item))
                            File.Delete(path+"\\"+item);
                    }
                    jso = "{msg:'修改成功！'}" ;

                }
            }


        }
        else
            jso = "url传递参数有误！";
        return jso;

    }

    public string baogaoBuhege(HttpContext context) {
        var stream = context.Request.InputStream;
        string tempFile = templetFilePath + "anbiao_buhege.docx";
        string json = new StreamReader(stream).ReadToEnd().Replace("{", "").Replace("}", "").Replace("\"", "");
        string ids = json.Split(':')[1].ToString();
        List<string> _tempBuhege = new List<string>();
        string _tempBuhgeStr = "";
        string outStr = "";
        Dictionary<string, string> dictionary = new Dictionary<string, string>();
        //string zone = jo.xm2_1Panding.ToString()=="合格"?"":"";//输出 深圳
        Document doc = new Document(tempFile);  /* 建立Document物件 */
                                                // Modifying Document Title, Subject and Author Name
        doc.BuiltInDocumentProperties.Title =ids+ "不合格报告";
        doc.BuiltInDocumentProperties.Subject = "不合格报告";
        doc.BuiltInDocumentProperties.Author = "LJQ";
        doc.BuiltInDocumentProperties.CreatedTime =  DateTime.Now;

        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        string _PS_BuHegeBaoGao="";
        if (ids != "")
        {
            string _tempSql = "select PS_ID,PS_DanWei,PS_RenYuan,PS_JieLun,PS_BuHege,PS_RiQiStart,PS_RiQiEnd,PS_BuHegeBaoGao from AnBiaoPingShen  where PS_ID='" + ids + "'";
            IDataReader reader = Class1.GetDataReader(_tempSql.ToString());
            while (reader.Read())
            {
                _PS_BuHegeBaoGao=reader["PS_BuHegeBaoGao"].ToString();
                dictionary.Add("ps_ID", reader["PS_ID"].ToString());
                dictionary.Add("ps_DanWei", reader["PS_DanWei"].ToString());
                dictionary.Add("ps_RenYuan", reader["PS_RenYuan"].ToString());
                string[] _tempRenyuan = reader["PS_RenYuan"].ToString().Split('，');
                dictionary.Add("ps_RenYuanShuLiang", _tempRenyuan.Length.ToString());

                dictionary.Add("ps_JieLun", reader["PS_JieLun"].ToString());
                _tempBuhgeStr = reader["PS_BuHege"].ToString();
                dictionary.Add("ps_RiQiStart", reader["PS_RiQiStart"].ToString());
                dictionary.Add("ps_RiQiEnd", reader["PS_RiQiEnd"].ToString());
                string timeNow = DateTime.Now.ToString("yyyy年MM月dd日");
                dictionary.Add("ps_Time", timeNow);
            }
        }

        string _BuHegeBaogaoDoc = _PS_BuHegeBaoGao.Replace("http://117.160.199.82:7777","d:\\yj\\kuangangs").Replace("/","\\");
        if (File.Exists(_BuHegeBaogaoDoc))
        {
            File.Delete(_BuHegeBaogaoDoc);
        }
        string _BuHegeBaogaoPdf = _PS_BuHegeBaoGao.Replace(".doc",".pdf");
        if (File.Exists(_BuHegeBaogaoPdf))
        {
            File.Delete(_BuHegeBaogaoPdf);
        }
        JObject jo = (JObject)JsonConvert.DeserializeObject("{\"bhg\":" + _tempBuhgeStr + "}");//或者JObject jo = JObject.Parse(jsonText);
                                                                                               /* Quick typed access to the first child Section node of the Document. */
        Section section = doc.FirstSection;

        /* Quick typed access to the Body child node of the Section. */
        Body body = section.Body;
        TableCollection tables = body.Tables;
        Aspose.Words.Tables.Table table = tables[0];
        string[] _XiangMu = { "BHG_ID", "BHG_Type", "BHG_ShiShi", "BHG_ZhengGai" };
        int _totalCount = 0;

        foreach (var name in jo["bhg"])
        {
            //创建行
            // Clone the last row in the table.
            Row clonedRow = (Row)table.LastRow.Clone(true);
            table.Rows.Add(clonedRow);

            // Remove all content from the cloned row's cells. This makes the row ready for
            // new content to be inserted into.
            int index = 0;
            foreach (Cell cell in clonedRow.Cells)
            {
                cell.RemoveAllChildren();
                builder.MoveToCell(0, table.Rows.Count - 1, index, 0);
                switch (index)
                {
                    case 0:
                        builder.ParagraphFormat.Alignment = ParagraphAlignment.Center;
                        builder.Write(_totalCount.ToString());
                        break;
                    case 1:
                        // Create a pattern for a word that starts with letter "M"  
                        //string pattern = ;  
                        // Create a Regex  
                        Regex rg = new Regex(@"\d+\.\d+(?:\.\d+)?");

                        // Long string  
                        string authors = name[_XiangMu[0]].ToString();
                        // Get all matches  
                        MatchCollection matchedAuthors = rg.Matches(authors);
                        if (matchedAuthors.Count > 0)
                        // Print all matched authors  
                        {
                            string[] _number = { "0", char.ConvertFromUtf32(0x006A), char.ConvertFromUtf32(0x006B), char.ConvertFromUtf32(0x006C), char.ConvertFromUtf32(0x006D), char.ConvertFromUtf32(0x006E), char.ConvertFromUtf32(0x006F), char.ConvertFromUtf32(0x0070), char.ConvertFromUtf32(0x0071), char.ConvertFromUtf32(0x0072) };
                            builder.ParagraphFormat.Alignment = ParagraphAlignment.Center;
                            string[] _leibie = matchedAuthors[0].Value.Split('.');
                            builder.Write(_leibie[0].ToString());
                            builder.Write(".");
                            builder.Write(_leibie[1].ToString());
                            if (_leibie.Length > 2)
                            {

                                builder.Font.Name = "Wingdings 2";
                                builder.Write(_number[Convert.ToInt16(_leibie[2])].ToString());

                            }

                        }
                        else
                            builder.Write(name[_XiangMu[0]].ToString());
                        break;
                    case 2:
                        builder.Font.Color = Color.Red;
                        builder.Write(name[_XiangMu[1]].ToString());
                        builder.Write("。");

                        builder.Font.Color = Color.Black;
                        builder.Write(name[_XiangMu[2]].ToString());
                        break;
                    case 3:
                        builder.Write(name[_XiangMu[3]].ToString());
                        break;
                    default: break;
                }

                builder.Font.Size = 20;
                builder.Font.Name = "宋体";
                index++;
            }
            _totalCount++;
            //var row=CreateRow(4,(new string[]{"1","2","3","4"}),doc); //创建一行
            //table.Rows.Insert(1,row); //将此行插入第一行的上方
            //// Add the row to the end of the table.

        }
        //dictionary.Add("ps_Beizhu", jo["bhg"]+"------"+jo.ToString());
        dictionary.Add("ps_Count", _totalCount.ToString());
        dictionary.Add("ps_BuHeGeCount", _totalCount.ToString());

        BookmarkCollection bookmarks = doc.Range.Bookmarks;

        foreach (KeyValuePair<string, string> kvp in dictionary)
        {

            Bookmark bookmark = doc.Range.Bookmarks[kvp.Key];
            bookmark.Text = kvp.Value;
        }
        string _savePath=saveFilePath  +ids+"\\"+ids+"不合格报告" ;
        string outFileDoc = _savePath+ ".doc";
        string outFilePdf =_savePath+".pdf";

        if (File.Exists(outFileDoc))
        {
            File.Delete(outFileDoc);
        }
        if (File.Exists(outFilePdf))
        {
            File.Delete(outFilePdf);
        }
        doc.Save(outFileDoc);
        doc.Save(outFilePdf); /* 将文件存档 ，在临时文件 *//* 将文件存档 ，在临时文件 */
        if (ids != "")
        {
            string _tempSql = "update AnBiaoPingShen set PS_BuHegeBaoGao ='" + urlconvertor(outFileDoc) + "' where PS_ID='" + ids + "'";
            Class1.ExecSql(_tempSql);
        }
        //return
        //       outStr.ToString() ;

        string _return_String="{\"doc\":\""+ urlconvertor(outFileDoc).ToString()+"\", \"pdf\":\""+ urlconvertor(outFilePdf).ToString()+"\"}";
        return _return_String;
    }



    public class DANWEISHENGCHAN {
        public string PS_ID {get;set;}
        public object PS_DanWeiShengChan{get;set;}
    }
    public string getDanWeiXiangQing(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string idsArray = json.Split(':')[1].ToString();
        StringBuilder querySelectSql = new StringBuilder("select PS_DanWeiShengChan from   [AnBiaoPingShen]    where PS_ID ='"+idsArray+"'");
        StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoPingShen] where PS_ID ='"+idsArray+"'");
        int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));
        IDataReader reader = Class1.GetDataReader(querySelectSql.ToString());

        StringBuilder jsonString = new StringBuilder("");
        jsonString.Append("{\"count\":"+SqlCount);
        jsonString.Append(",\"Data\":");
        string jso = "";
        if (SqlCount == 0)
        {
            jsonString.Append("\"\"}");
            jso = jsonString.ToString();
        }
        else
        {
            while (reader.Read())
            {
                if (reader["PS_DanWeiShengChan"].ToString() == "")
                    jsonString.Append("\"\"");
                else
                {
                    jsonString.Append(reader["PS_DanWeiShengChan"].ToString());

                }
            }
            jsonString.Append("}");

        }
        return jsonString.ToString();
    }
    public string updateDanWeiXiangQing(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Trim();
        // json = json.Substring(0, json.Length - 1);
        DANWEISHENGCHAN _tempDetail = JsonConvert.DeserializeObject<DANWEISHENGCHAN>(json);//反序列化;
        string jso = "工厂信息修改成功！";
        string _PS_ID = _tempDetail.PS_ID;
        var _TYPE = _tempDetail.PS_DanWeiShengChan;

        if (_tempDetail.PS_ID != "")
        {

            StringBuilder querySelectSql = new StringBuilder("update [AnBiaoPingShen] set   [PS_DanWeiShengChan]  ='" + _TYPE.ToString() + "'");
            querySelectSql.Append("    where PS_ID ='" + _PS_ID + "'");
            //Class1.ExecSel(querySelectSql.ToString());
            string  _jso = querySelectSql.ToString();
            Class1.ReturnValue(_jso);


        }
        else
            jso = "url传递参数有误！";
        return jso;

    }
    #region 评审报告 
    public class PSBAOGAO {
        public string PS_ID { get; set; }
        public object PS_BaoGao { get; set; }
        public string PS_BaoGaoLink { get; set; }
        public string PS_JieLunDetail { get; set; }
        public List<object> PS_BuHege { get; set; }
    }

    public string getBaoGao(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string idsArray = json.Split(':')[1].ToString();
        string jso = "评审报告信息获取成功！";

        if (idsArray!= "")
        {

            StringBuilder querySelectSql = new StringBuilder("select  count(*)     from [AnBiaoPingShen] ");
            querySelectSql.Append("    where PS_ID ='" + idsArray + "'");
            //Class1.ExecSel(querySelectSql.ToString());
            StringBuilder querySql = new StringBuilder("select  PS_BaoGao ,PS_BaoGaoLink,PS_JieLunDetail,PS_BuHege from [AnBiaoPingShen]  ");
            querySql.Append("    where PS_ID ='" + idsArray + "'");



            int SqlCount = Convert.ToInt16(Class1.ReturnValue(querySelectSql.ToString()));
            IDataReader reader = Class1.GetDataReader(querySql.ToString());
            StringBuilder jsonString = new StringBuilder();
            jsonString.Append("{\"count\":" + SqlCount);
            jsonString.Append(",\"Data\":");
            if (SqlCount == 0)
            {
                jsonString.Append("\"\"}");
                jso = jsonString.ToString();
            }
            else
            {

                while (reader.Read())
                {
                    jsonString.Append("{");
                    jsonString.AppendFormat("\"PS_BaoGao\":{0}", reader["PS_BaoGao"].ToString());
                    jsonString.Append("},");
                    jsonString.AppendFormat("\"PS_BuHege\":{0}", reader["PS_BuHege"].ToString());
                    jsonString.Append(",");
                    if( reader["PS_BaoGaoLink"].ToString().IndexOf("\"")!=-1)
                        jsonString.AppendFormat("\"PS_BaoGaoLink\":{0}", reader["PS_BaoGaoLink"].ToString());
                    else
                        jsonString.AppendFormat("\"PS_BaoGaoLink\":\"{0}\"", reader["PS_BaoGaoLink"].ToString());

                    jsonString.Append(",");
                    string myEncodedString = HttpUtility.HtmlEncode(reader["PS_JieLunDetail"].ToString().Trim());

                    jsonString.AppendFormat("\"PS_JieLunDetail\":\"{0}\"",  myEncodedString );
                    jsonString.Append("");
                }
                jso = jsonString.ToString();
                reader.Close();
                jso += "}";
            }


        }
        else
            jso = "url传递参数有误！";
        return jso;

    }
    public class _yiju {
        public  string YJ_Select  { get; set; }
        public  string YJ_BiaoZhun  { get; set; }
        public  string _X_ROW_KEY  { get; set; }

    }
    public class _buhege {
        public string BHG_ID { get; set; }
        public string id { get; set; }
        public string value { get; set; }
        public string BHG_Type { get; set; }
        public string BHG_ShiShi { get; set; }
        public string BHG_ZhengGai { get; set; }
        public bool isEdit { get; set; }
        public bool isAdd { get; set; }
    }
    public class _chanpin{

        public  string ZG_BiaoTi  { get; set; }
        public  string ZG_YaoQiu  { get; set; }
        public  string ZG_LuoShi  { get; set; }
        public  string ZG_BeiZhu  { get; set; }
        public  string _X_ROW_KEY  { get; set; }
    }
    public class _BG_Detail
    {
        public  string ps_AllTime  { get; set; }
        public  List<_yiju> PS_YiJu  { get; set; }
        public  List<_chanpin> PS_hegeMulu  { get; set; }
        public  List<_chanpin> PS_buhegeMulu  { get; set; }
        public  List<_chanpin> PS_qianciZhenggai  { get; set; }
        public  string ps_2_1  { get; set; }
        public  string ps_2_2  { get; set; }
        public  string ps_2_3  { get; set; }
        public  string ps_2_4  { get; set; }
        public  string ps_2_5  { get; set; }
        public  string ps_2_6  { get; set; }
        public  string ps_2_7  { get; set; }
        public  string ps_2_8  { get; set; }
        public  string ps_2_9  { get; set; }
        public  string ps_2_10  { get; set; }
        public  string ps_2_11  { get; set; }
        public  string ps_2_12  { get; set; }
        public  string ps_2_13  { get; set; }
        public  string ps_2_14  { get; set; }
        public  string ps_2_15  { get; set; }
        public  string ps_2_16  { get; set; }
        public  string PS_ZhengGaiTime  { get; set; }
    }
    public string shengchengPSBaoGao(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Replace("{", "").Replace("}", "").Replace("\"", "");
        string idsArray =string.IsNullOrEmpty(json)? "23PJ3020": json.Split(':')[1].ToString();
        //string idsArray = "23PJ3020";
        string PS_DanWei = "";
        string PS_RiQiStart = "";
        string PS_RiQiEnd = "";
        string PS_BaoGao = "";
        string PS_BuHege = "";
        string PS_DanWeiShengChan = "";
        string PS_JieLunDetail = "";
        string PS_Type = "";

        #region 报告中的所有书签
        string PS_ID = "";
        string PS_ChangJia = "";
        string PS_RenYuan = "";
        string PS_OEM = "";
        string PS_StartTime = "";
        string PS_EndTime = "";
        string PS_RenYuan1 = "";
        string PS_RenYuan_Count = "";
        string PS_StartTime1 = "";
        string PS_EndTime1 = "";
        string PS_Date_Count = "";
        string PS_ChangJia1 = "";
        string PS_LeiBie = "";
        string PS_YiJu = "";
        string gcMingcheng = "";
        string gcZhucedi = "";
        string gcShengchandi = "";
        string gcFaren = "";
        string gcFarenXueli = "";
        string gcFarenTel = "";
        string gcDanweiFuzeren = "";
        string gcDanweiFuzerenXueli = "";
        string gcDanweiFuzerenTel = "";
        string gcJishuFuzeren = "";
        string gcJishuFuzerenXueli = "";
        string gcJishuFuzerenTel = "";
        string gcZhiliangFuzeren = "";
        string gcZhiliangFuzerenXueli = "";
        string gcZhiliangFuzerenTel = "";
        string gcAnbiaoFuzeren = "";
        string gcAnbiaoFuzerenXueli = "";
        string gcAnbiaoFuzerenTel = "";
        string gcAnbiaoLianxiren = "";
        string gcAnbiaoLianxirenXueli = "";
        string gcAnbiaoLianxirenTel = "";
        string gcZhigongCount = "";
        string gcJishuCount = "";
        string gcShengchanShebei = "";
        string gcJianyanShebei = "";
        string gcIsoRenzheng = "";
        string gcQitaRenzheng = "";
        string gcShenchanmoshi = "";
        string gcShengchanNengli = "";
        string gcShijiChanliang = "";
        string gcBeizhu = "";
        string ps_bhg = "";
        #endregion
        object gc_obj = new object();
        string tempFile = templetFilePath + "anbiao_baogao.docx";
        //string zone = jo.xm2_1Panding.ToString()=="合格"?"":"";//输出 深圳
        Document doc = new Document(tempFile);  /* 建立Document物件 */
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        Aspose.Words.BookmarkCollection bookmarkManager = doc.Range.Bookmarks;
        StringBuilder sb = new StringBuilder();

        foreach (Bookmark bookmark in bookmarkManager)
        {
            // 获取书签信息  
            sb.Append(bookmark.Name).Append(",").Append("<br/>");
        }
        List<_yiju> yiJu = new List<_yiju>();
        List<_buhege> buHege = new List<_buhege>();

        List<_chanpin> chanPin1 = new List<_chanpin>();
        List<_chanpin> chanPin2 = new List<_chanpin>();
        List<_chanpin> chanPin3 = new List<_chanpin>();
        _BG_Detail bg_detail = new _BG_Detail();
        StringBuilder querySelectSql = new StringBuilder("select [id],[PS_ID],[PS_DanWei],[PS_RenYuan],[PS_RiQiStart],[PS_RiQiEnd],[PS_BaoGao],[PS_BuHege],[PS_DanWeiShengChan],[PS_JieLunDetail],[PS_Type] from   [AnBiaoPingShen]    where PS_ID ='" + idsArray + "'");
        StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoPingShen] where PS_ID ='" + idsArray + "'");
        int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));
        IDataReader reader = Class1.GetDataReader(querySelectSql.ToString());
        while (reader.Read())
        {
            PS_ID = reader["PS_ID"].ToString();
            PS_DanWei = reader["PS_DanWei"].ToString();
            PS_RiQiStart = reader["PS_RiQiStart"].ToString();
            PS_RiQiEnd = reader["PS_RiQiEnd"].ToString();
            PS_BuHege = reader["PS_BuHege"].ToString();
            PS_DanWeiShengChan = reader["PS_DanWeiShengChan"].ToString();
            PS_JieLunDetail = reader["PS_JieLunDetail"].ToString();
            PS_RenYuan = reader["PS_RenYuan"].ToString();
            PS_Type = reader["PS_Type"].ToString();
            PS_BaoGao = reader["PS_BaoGao"].ToString();
            ps_bhg = reader["PS_BuHege"].ToString();
            buHege =JsonConvert.DeserializeObject<List<_buhege>>(reader["PS_BuHege"].ToString());
        }

        string _zhuzhang = PS_RenYuan.Replace('，', '、').Replace(',', '、').Split('、')[0].ToString();
        string _zhuyuan =String.Concat( PS_RenYuan.Replace('，', '、').Replace(',', '、').Split('、').Skip(1).ToArray());

        Dictionary<string, string> bookMarkList = JsonConvert.DeserializeObject<Dictionary<string, string>>(PS_DanWeiShengChan);//表1单位情况
        bg_detail =  JsonConvert.DeserializeObject<_BG_Detail>(PS_BaoGao);//表1单
        yiJu = bg_detail.PS_YiJu;//依据
        gcShenchanmoshi =  bookMarkList["gcShenchanmoshi"];//工厂生产模式

        bookMarkList.Add("PS_Date_Count", bg_detail.ps_AllTime);
        bookMarkList.Add("PS_2_1", bg_detail.ps_2_1);
        bookMarkList.Add("PS_2_2", bg_detail.ps_2_2);
        bookMarkList.Add("PS_2_3", bg_detail.ps_2_3);
        bookMarkList.Add("PS_2_4", bg_detail.ps_2_4);
        bookMarkList.Add("PS_2_5", bg_detail.ps_2_5);
        bookMarkList.Add("PS_2_6", bg_detail.ps_2_6);
        bookMarkList.Add("PS_2_7", bg_detail.ps_2_7);
        bookMarkList.Add("PS_2_8", bg_detail.ps_2_8);
        bookMarkList.Add("PS_2_9", bg_detail.ps_2_9);
        bookMarkList.Add("PS_2_10", bg_detail.ps_2_10);
        bookMarkList.Add("PS_2_11", bg_detail.ps_2_11);
        bookMarkList.Add("PS_2_12", bg_detail.ps_2_12);
        bookMarkList.Add("PS_2_13", bg_detail.ps_2_13);
        bookMarkList.Add("PS_2_14", bg_detail.ps_2_14);
        bookMarkList.Add("PS_2_15", bg_detail.ps_2_15);
        bookMarkList.Add("PS_2_16", bg_detail.ps_2_16);

        if (!string.IsNullOrEmpty(bg_detail.PS_ZhengGaiTime))
        {
            Regex regex = new Regex(@"(\d+)-(\d+)-(\d+)");
            string result = regex.Replace(bg_detail.PS_ZhengGaiTime, "$1年$2月$3日");
            bookMarkList.Add("PS_ZhengGaiTime", result);
        }
        bookMarkList.Add("PS_RenYuan_ZhuZhang", _zhuzhang);
        bookMarkList.Add("PS_RenYuan_ChengYuan", _zhuyuan);
        bookMarkList.Add("PS_RenYuan", PS_RenYuan);
        bookMarkList.Add("PS_RenYuan1", PS_RenYuan);

        string xuanzhong = char.ConvertFromUtf32(0x25A0);
        string weixuanzhong = char.ConvertFromUtf32(0x25A1);

        bookMarkList.Add("PS_ID", PS_ID);
        bookMarkList.Add("PS_YiJu", PS_ID);
        bookMarkList.Add("PS_ChangJia", PS_DanWei);
        bookMarkList.Add("PS_ChangJia1", PS_DanWei);
        bookMarkList.Add("PS_StartTime", PS_RiQiStart);
        bookMarkList.Add("PS_StartTime1", PS_RiQiStart.Substring(0,PS_RiQiStart.IndexOf('日')+1));
        bookMarkList.Add("PS_EndTime1", PS_RiQiEnd.Substring(0,PS_RiQiEnd.IndexOf('日')+1));
        bookMarkList.Add("PS_EndTime2", PS_RiQiEnd);
        bookMarkList.Add("PS_EndTime3", PS_RiQiEnd.Substring(0,PS_RiQiEnd.IndexOf('日')+1));
        StringBuilder _type = new StringBuilder();
        StringBuilder _type1 = new StringBuilder();
        _type.Append(@"■ 评价工厂的生产能力、检验能力、人员能力、产品质量保证能力及产品一致性控制等是否符合安全标志审核发放实施规则的要求。
□ 评价工厂生产与检验的实施、产品质量管理体系的运行及产品一致性控制等是否持续符合安全标志审核发放实施规则的要求。");
        _type1.Append(@"□ 评价工厂的生产能力、检验能力、人员能力、产品质量保证能力及产品一致性控制等是否符合安全标志审核发放实施规则的要求。
■ 评价工厂生产与检验的实施、产品质量管理体系的运行及产品一致性控制等是否持续符合安全标志审核发放实施规则的要求。");
        if ("申办评审" == PS_Type)
        {
            bookMarkList.Add("PS_LeiBie", "■申办评审；□监督评审");
            bookMarkList.Add("PS_MuDi", _type.ToString());
        }
        else
        {
            bookMarkList.Add("PS_LeiBie", "□申办评审；■监督评审");
            bookMarkList.Add("PS_MuDi", _type1.ToString());

        }

        //替换书签
        for (int t = 0; t < bookMarkList.Count; t++)
        {
            KeyValuePair<string, string> kvp = bookMarkList.ElementAt(t);
            Bookmark bookmark = doc.Range.Bookmarks[kvp.Key];
            if (bookmark != null)
            {
                bookmark.Text = "";
                builder.MoveToBookmark(kvp.Key, true, false);
                if (kvp.Key.IndexOf("YiJu") != -1)
                {
                    bookmark.Remove();

                    foreach (_yiju s in yiJu)
                    {
                        string _s =(s.YJ_Select == "1" ? "<p class=\"ql-align-justify\" style='font-family:宋体;'>■ " : "<p class=\"ql-align-justify\" style='font-family:宋体;'>□ ") + s.YJ_BiaoZhun+"</p>";
                        builder.InsertHtml(_s);
                    }
                }
                else
                {
                    if (kvp.Value.IndexOf('<') != -1)
                    {
                        bookmark.Remove();
                        builder.InsertHtml(kvp.Value.Trim().Replace("class=\"ql-align-justify\"", "class=\"ql-align-justify\" style='font-family:宋体;'").Replace("<br>", "").Replace("&nbsp;", "").Trim());
                        // builder.Write(kvp.Value);
                    }
                    else
                        builder.Write(kvp.Value);
                }
            }
        }
        //设置每段的格式
        foreach (Section _sec in doc.Sections)
        {
            ParagraphCollection paragraphs = _sec.Body.Paragraphs;
            int _start = 999;
            // 通过循环来获取段落中的内容
            for (int i = 0; i < paragraphs.Count; i++)
            {
                Paragraph _pn  = paragraphs[i];

                if (_pn.ParagraphFormat.Style.Name == "ql-align-justify")
                {
                    _pn.ParagraphFormat.ClearFormatting();
                    _pn.ParagraphFormat.Style.Font.Name = "宋体";
                    _pn.ParagraphFormat.Alignment = ParagraphAlignment.Left;
                    _pn.ParagraphFormat.FirstLineIndent = 26;
                    _pn.ParagraphFormat.LineSpacingRule = LineSpacingRule.Multiple;
                    _pn.ParagraphFormat.LineSpacing = 18;
                    if (string.IsNullOrEmpty(_pn.NextSibling.GetText().Trim()))
                    {
                        _pn.NextSibling.Remove();
                    }

                }
            }
        }

        // 获取表格 不合格项
        TableCollection tables = doc.Sections[5].Body.Tables;
        Aspose.Words.Tables.Table _table = tables[0];
        int _index = 1;
        foreach(var obj in buHege) {

            Row insertRow = (Row)_table.Rows[0].Clone(true);
            foreach (Cell cell in insertRow.Cells)
            {
                cell.RemoveAllChildren();
            }
            for (int j = 0; j < _table.FirstRow.Cells.Count; j++)
            {

                var cl = insertRow.Cells[j];
                Paragraph p = new Paragraph(doc);
                Paragraph p1 = new Paragraph(doc);
                p.ParagraphFormat.Alignment = ParagraphAlignment.Left;
                p.ParagraphFormat.Style.Font.Name = "宋体";
                switch (j) {
                    case 0:
                        p.AppendChild(new Run(doc,_index.ToString()));
                        cl.AppendChild(p);
                        break;
                    case 1:
                        p.AppendChild(new Run(doc,obj.BHG_ID));
                        cl.AppendChild(p);
                        break;
                    case 2:
                        // Finally, add some content to do the document. Create a run,
                        // set its appearance and contents, and then append it as a child to the paragraph.
                        Run run = new Run(doc);
                        run.Text ="■"+( obj.BHG_Type=="不符"?"不符合":"基本符合");
                        run.Font.Color =obj.BHG_Type=="不符"? Color.Red:Color.Blue;
                        p.AppendChild(run);
                        cl.AppendChild(p);
                        p1.ParagraphFormat.Style.Font.Color =Color.Black;
                        p1.AppendChild(new Run(doc,string.IsNullOrEmpty( obj.BHG_ShiShi)?"":obj.BHG_ShiShi));
                        cl.AppendChild(p1);

                        break;
                    case 3:
                        p.AppendChild(new Run(doc,string.IsNullOrEmpty( obj.BHG_ZhengGai)?"":obj.BHG_ZhengGai));
                        cl.AppendChild(p);
                        break;
                }
            }
            _table.Rows.Insert(_index, insertRow);



            _index++;
        }
        // 获取表格 合格产品目录 
        TableCollection tables_6 = doc.Sections[6].Body.Tables;
        Aspose.Words.Tables.Table _table_6 = tables_6[0];
        int _index_6 = 1;
        var hege_mulu =  bg_detail.PS_hegeMulu;
        if(hege_mulu != null)
        {
            Row _row = _table_6.Rows[0];
            foreach (var obj in hege_mulu)
            {
                for( int _t = 0;_t<5;_t++)
                {
                    _row = _table_6.Rows[_index_6];
                    // Get reference to the cell
                    Cell _cell = _row.Cells[_t];
                    builder.MoveTo(_cell.FirstChild);
                    switch (_t)
                    {
                        case 0:
                            builder.Write(obj.ZG_BiaoTi);
                            break;
                        case 1:
                            builder.Write(obj.ZG_YaoQiu);
                            break;
                        case 2:
                            builder.Write(obj.ZG_LuoShi);
                            break;
                        case 3:
                            builder.Write(obj.ZG_BeiZhu);
                            break;
                        default:
                            builder.Write(gcShenchanmoshi);
                            break;
                    }
                }
                _index_6++;
            }
            _row = _table_6.Rows[_index_6];
            Cell  _cell_temp = _row.Cells[1];
            builder.MoveTo(_cell_temp.FirstChild);
            builder.Write("以下空白");
        }
        // 获取表格 不合格产品目录 
        TableCollection tables_7 = doc.Sections[7].Body.Tables;
        Aspose.Words.Tables.Table _table_7 = tables_7[0];
        int _index_7 = 1;
        var buhege_mulu =  bg_detail.PS_buhegeMulu;
        if(buhege_mulu != null)
        {
            Row _row = _table_7.Rows[0];
            foreach (var obj in buhege_mulu)
            {
                for( int _t = 0;_t<5;_t++)
                {
                    _row = _table_7.Rows[_index_7];
                    // Get reference to the cell
                    Cell _cell = _row.Cells[_t];
                    builder.MoveTo(_cell.FirstChild);
                    switch (_t)
                    {
                        case 0:
                            builder.Write(obj.ZG_BiaoTi);
                            break;
                        case 1:
                            builder.Write(obj.ZG_YaoQiu);
                            break;
                        case 2:
                            builder.Write(obj.ZG_LuoShi);
                            break;
                        case 3:
                            builder.Write(obj.ZG_BeiZhu);
                            break;
                        default:
                            builder.Write(gcShenchanmoshi);
                            break;
                    }
                }
                _index_7++;
            }
            _row = _table_7.Rows[_index_7];
            Cell  _cell_temp = _row.Cells[1];
            builder.MoveTo(_cell_temp.FirstChild);
            builder.Write("以下空白");
        }
        // 获取表格 前次整改情况 
        TableCollection tables_8 = doc.Sections[8].Body.Tables;
        Aspose.Words.Tables.Table _table_8 = tables_8[0];
        int _index_8 = 1;
        var zhenggai =  bg_detail.PS_qianciZhenggai;
        if(zhenggai != null)
        {
            Row _row = _table_8.Rows[0];
            foreach (var obj in zhenggai)
            {
                Row cloneOfLastRow = (Row) _table_8.LastRow.Clone(true);

                _table_8.Rows.Add(cloneOfLastRow);

                for( int _t = 0;_t<5;_t++)
                {
                    _row = _table_8.Rows[_index_8];
                    // Get reference to the cell
                    Cell _cell = _row.Cells[_t];
                    builder.MoveTo(_cell.FirstChild);
                    Paragraph _p = (Paragraph)_cell.FirstChild;
                    switch (_t)
                    {
                        case 0:
                            _p.RemoveAllChildren();
                            _p.AppendChild(new Run(doc,_index_8.ToString()));
                            break;
                        case 1:
                            _p.RemoveAllChildren();
                            _p.AppendChild(new Run(doc,obj.ZG_BiaoTi));
                            break;
                        case 2:
                            _p.RemoveAllChildren();
                            _p.AppendChild(new Run(doc,obj.ZG_YaoQiu));
                            break;
                        case 3:
                            _p.RemoveAllChildren();
                            _p.AppendChild(new Run(doc,obj.ZG_LuoShi));
                            break;
                        case 4:
                            _p.RemoveAllChildren();
                            _p.AppendChild(new Run(doc,obj.ZG_BeiZhu));
                            break;

                    }
                }
                _index_8++;
            }
        }

        //        InsertRowToTable(_table,ParagraphAlignment.Left,"宋体",0,buHege,doc);

        string _savePath=saveFilePath  +PS_ID+"\\"+PS_ID+"评审报告" ;
        string outFileDoc = _savePath+ ".docx";
        string outFilePdf =_savePath+".pdf";

        if (File.Exists(outFileDoc))
        {
            File.Delete(outFileDoc);
        }
        if (File.Exists(outFilePdf))
        {
            File.Delete(outFilePdf);
        }
        doc.Save(outFileDoc);
        doc.Save(outFilePdf); /* 将文件存档 ，在临时文件 *//* 将文件存档 ，在临时文件 */
        if (PS_ID != "")
        {
            string _tempSql = "update AnBiaoPingShen set [PS_BaoGaoLink] ='" + urlconvertor(outFileDoc) + "' where PS_ID='" + PS_ID + "'";
            Class1.ExecSql(_tempSql);
        }
        //return
        //       outStr.ToString() ;

        string _return_String="{\"doc\":\""+ urlconvertor(outFileDoc).ToString()+"\", \"pdf\":\""+ urlconvertor(outFilePdf).ToString()+"\"}";
        return _return_String;


    }

    /// <summary>
    /// 在表格中插入行
    /// </summary>
    /// <param name="table">表格对象</param>
    /// <param name="cellAlignment">插入表格的单元格对齐方式</param>
    /// <param name="FontName">字体名称</param>
    /// <param name="startRow">从当前获取表格的哪一行开始插入</param>
    /// <param name="list">要插入的list</param>
    /// <param name="doc">当前文档的document</param>
    /// <returns></returns>
    public static bool InsertRowToTable(Aspose.Words.Tables.Table table, ParagraphAlignment cellAlignment, string FontName, int startRow, IList list, Document doc)
    {
        try
        {
            int positionRow = startRow + 1;
            DataTable dataTable = ListToDataTable(list);
            for (int i = 0; i < dataTable.Rows.Count; i++)
            {
                Row insertRow = (Row)table.Rows[startRow].Clone(true);
                foreach (Cell cell in insertRow.Cells)
                {
                    cell.RemoveAllChildren();
                }
                for (int j = 0; j < dataTable.Columns.Count; j++)
                {

                    var cl = insertRow.Cells[j];
                    Paragraph p = new Paragraph(doc);
                    p.ParagraphFormat.Alignment = cellAlignment;
                    p.ParagraphFormat.Style.Font.Name = FontName;
                    p.AppendChild(new Run(doc, dataTable.Rows[i][j].ToString()));
                    cl.AppendChild(p);
                }
                table.Rows.Insert(positionRow, insertRow);
                positionRow++;
            }
            return true;
        }
        catch (Exception e)
        {
            throw e;
        }
    }
    /// <summary>
    /// C# List转换成DataTable 列顺序根据创建Model顺序
    /// </summary>
    /// <param name="list"></param>
    /// <returns></returns>
    public static DataTable ListToDataTable(IList list)
    {
        DataTable result = new DataTable();
        if (list.Count > 0)
        {
            PropertyInfo[] propertys = list[0].GetType().GetProperties();
            foreach (PropertyInfo pi in propertys)
            {
                //获取类型
                Type colType = pi.PropertyType;
                //当类型为Nullable<>时
                if ((colType.IsGenericType) && (colType.GetGenericTypeDefinition() == typeof(Nullable<>)))
                {
                    colType = colType.GetGenericArguments()[0];
                }
                result.Columns.Add(pi.Name, colType);
            }
            for (int i = 0; i < list.Count; i++)
            {
                ArrayList tempList = new ArrayList();
                foreach (PropertyInfo pi in propertys)
                {
                    object obj = pi.GetValue(list[i], null);
                    tempList.Add(obj);
                }
                object[] array = tempList.ToArray();
                result.LoadDataRow(array, true);
            }
        }
        return result;
    }


    public string updateBaoGao(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().ToString().Trim();
        PSBAOGAO _tempDetail = JsonConvert.DeserializeObject<PSBAOGAO>(json);//反序列化;
        string jso = "评审报告信息修改成功！";
        string _PS_ID = _tempDetail.PS_ID;
        string _TYPE =JsonConvert.SerializeObject( _tempDetail.PS_BaoGao);
        string _BGLink =JsonConvert.SerializeObject( _tempDetail.PS_BaoGaoLink);
        string _Detail =JsonConvert.SerializeObject( _tempDetail.PS_JieLunDetail);
        string _ps_buhege =JsonConvert.SerializeObject( _tempDetail.PS_BuHege);

        StringBuilder querySelectSql = new StringBuilder();
        if (_PS_ID!= "")
        {

            querySelectSql.Append("update [AnBiaoPingShen] set   [PS_BaoGao]  ='" + _TYPE.ToString() + "',[PS_BaoGaoLink] ='" + _BGLink.ToString() + "',[PS_BuHege] ='" + _ps_buhege.ToString() + "',[PS_JieLunDetail] ='" + _Detail.ToString() + "'");
            querySelectSql.Append("    where PS_ID ='" + _PS_ID + "'");
            Class1.ExecCommand(querySelectSql.ToString());



        }
        else
            jso = "url传递参数有误！";
        return jso+"";

    }
    #endregion
    #region 不合格部分
    public class BUHEGE {
        public string PS_ID { get; set; }
        public object[] PS_BuHeGe { get; set; }
    }
    public string getBuHeGe(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string idsArray = json.Split(':')[1].ToString();
        string jso = "不合格信息获取成功！";

        if (idsArray!= "")
        {

            StringBuilder querySelectSql = new StringBuilder("select  count(*)     from [AnBiaoPingShen] ");
            querySelectSql.Append("    where PS_ID ='" + idsArray + "'");
            //Class1.ExecSel(querySelectSql.ToString());
            StringBuilder querySql = new StringBuilder("select  PS_BuHege ,PS_BuHegeBaoGao from [AnBiaoPingShen]  ");
            querySql.Append("    where PS_ID ='" + idsArray + "'");



            int SqlCount = Convert.ToInt16(Class1.ReturnValue(querySelectSql.ToString()));
            IDataReader reader = Class1.GetDataReader(querySql.ToString());
            StringBuilder jsonString = new StringBuilder();
            jsonString.Append("{\"count\":" + SqlCount);
            jsonString.Append(",\"Data\":");
            if (SqlCount == 0)
            {
                jsonString.Append("\"\"}");
                jso = jsonString.ToString();
            }
            else
            {

                while (reader.Read())
                {
                    jsonString.Append("{");
                    jsonString.AppendFormat("\"PS_BuHege\":{0}", reader["PS_BuHege"].ToString());
                    jsonString.Append("},");
                    jsonString.Append("");
                    jsonString.AppendFormat("\"PS_BuHegeBaoGao\":\"{0}\"", reader["PS_BuHegeBaoGao"].ToString());
                    jsonString.Append("");
                }
                jso = jsonString.ToString();
                reader.Close();
                jso += "}";
            }


        }
        else
            jso = "url传递参数有误！";
        return jso;

    }
    public string updateBuHeGe(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().ToString().Trim();
        BUHEGE _tempDetail = JsonConvert.DeserializeObject<BUHEGE>(json);//反序列化;
        string jso = "不合格信息修改成功！";
        string _PS_ID = _tempDetail.PS_ID;
        string _TYPE =JsonConvert.SerializeObject( _tempDetail.PS_BuHeGe);
        StringBuilder querySelectSql = new StringBuilder();
        if (_PS_ID!= "")
        {

            querySelectSql.Append("update [AnBiaoPingShen] set   [PS_BuHege]  ='" + _TYPE.ToString() + "'");
            querySelectSql.Append("    where PS_ID ='" + _PS_ID + "'");
            Class1.ExecCommand(querySelectSql.ToString());



        }
        else
            jso = "url传递参数有误！";
        return jso+"";

    }
    #endregion
    #region 单位 设备部分
    public class DANWEISHEBEI {
        public string SB_ID {get;set;}
        public string SB_BianHao {get;set;}
        public string SB_PS_ID {get;set;}
        public string SB_Type {get;set;}
        public string SB_Name {get;set;}
        public string SB_XingHao {get;set;}
        public string SB_JingDu {get;set;}
        public string SB_ShuLiang {get;set;}
        public string SB_ZhuangTai {get;set;}
        public string SB_DeleteFlag {get;set;}
        public string SB_EditTIme {get;set;}
        public string SB_AddTime {get;set;}
    }

    public string getDanWeiSheBei(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd().Replace("{", "").Replace("}", "").Replace("\"", "");
        string[] jsonArray = json.Split(',');
        string jso = "";

        if (jsonArray.Length > 1)
        {
            string[] psidArray = jsonArray[1].ToString().Split(':');
            string _PS_ID = psidArray[1];
            string[] typedArray = jsonArray[0].ToString().Split(':');
            string _TYPE = typedArray[1];

            //			return _PS_ID +'/'+_TYPE;

            if (_PS_ID != "" && _TYPE != "")
            {
                StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoDanWeiSheBei] where SB_DeleteFlag ='0'");
                StringBuilder querySql = new StringBuilder("select  *  from [AnBiaoDanWeiSheBei] where SB_DeleteFlag ='0'");

                querySql.Append("  and  SB_PS_ID like '%" + _PS_ID + "%'");
                querySql.Append("  and  SB_Type like '%" + _TYPE + "%'");
                querySql.Append("  order by SB_ID asc");
                queryCountSql.Append("  and  SB_PS_ID like '%" + _PS_ID + "%'");
                queryCountSql.Append("  and  SB_Type like '%" + _TYPE + "%'");

                int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));
                IDataReader reader = Class1.GetDataReader(querySql.ToString());
                StringBuilder jsonString = new StringBuilder();
                jsonString.Append("{\"count\":" + SqlCount);
                jsonString.Append(",\"Data\":");
                if (SqlCount == 0)
                {
                    jsonString.Append("\"\"}");
                    jso = jsonString.ToString();
                }
                else
                {
                    jsonString.Append("[");

                    while (reader.Read())
                    {
                        jsonString.Append("{");
                        jsonString.AppendFormat("\"SB_ID\":\"{0}\"", reader["SB_ID"].ToString());
                        jsonString.AppendFormat(",\"SB_BianHao\":\"{0}\"", reader["SB_BianHao"].ToString());
                        jsonString.AppendFormat(",\"SB_PS_ID\":\"{0}\"", reader["SB_PS_ID"].ToString());
                        jsonString.AppendFormat(",\"SB_Type\":\"{0}\"", reader["SB_Type"].ToString());
                        jsonString.AppendFormat(",\"SB_Name\":\"{0}\"", reader["SB_Name"].ToString());
                        jsonString.AppendFormat(",\"SB_XingHao\":\"{0}\"", reader["SB_XingHao"].ToString());
                        jsonString.AppendFormat(",\"SB_JingDu\":\"{0}\"", reader["SB_JingDu"].ToString());
                        jsonString.AppendFormat(",\"SB_ShuLiang\":\"{0}\"", reader["SB_ShuLiang"].ToString());
                        jsonString.AppendFormat(",\"SB_ZhuangTai\":\"{0}\"", reader["SB_ZhuangTai"].ToString());
                        jsonString.AppendFormat(",\"SB_DeleteFlag\":\"{0}\"", reader["SB_DeleteFlag"].ToString());
                        jsonString.AppendFormat(",\"SB_EditTIme\":\"{0}\"", reader["SB_EditTIme"].ToString());
                        jsonString.AppendFormat(",\"SB_AddTime\":\"{0}\"", reader["SB_AddTime"].ToString());
                        jsonString.Append("},");
                    }

                    jso = jsonString.ToString().Substring(0, jsonString.ToString().Length - 1);
                    jso += "]";
                    reader.Close();
                    jso += "}";
                }
            }
            else
                jso = "编号或类型错误！";

        }
        else
            jso = "提供的参数不足，请确保任务编号和设备类型！";
        return jso;
    }
    public string editDanWeiSheBei(HttpContext context)
    {
        string SB_ID ="";
        string SB_BianHao ="";
        string SB_PS_ID ="";
        string SB_Type ="";
        string SB_Name ="";
        string SB_XingHao ="";
        string SB_JingDu ="";
        string SB_ShuLiang ="";
        string SB_ZhuangTai ="";
        string SB_DeleteFlag ="";
        string SB_EditTIme ="";
        string SB_AddTime ="";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd();
        DANWEISHEBEI _tempDetail = JsonConvert.DeserializeObject<DANWEISHEBEI>(json);//反序列化;
        string sql = "";
        string timeNow = DateTime.Now.ToString("yyyyMMddHHmmss");
        StringBuilder _UPDATE_SQL = new StringBuilder("update [AnBiaoDanWeiSheBei] set ");
        _UPDATE_SQL.Append("SB_EditTime ='" + timeNow+ "',");
        if (_tempDetail != null) {
            if(!string.IsNullOrEmpty(_tempDetail.SB_ID)) {SB_ID= _tempDetail.SB_ID;} else SB_ID="00";
            if(!string.IsNullOrEmpty(_tempDetail.SB_BianHao)) {SB_BianHao= _tempDetail.SB_BianHao;_UPDATE_SQL.Append("SB_BianHao='"+SB_BianHao+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_PS_ID)) {SB_PS_ID= _tempDetail.SB_PS_ID;_UPDATE_SQL.Append("SB_PS_ID='"+SB_PS_ID+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_Type)) {SB_Type= _tempDetail.SB_Type;_UPDATE_SQL.Append("SB_Type='"+SB_Type+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_Name)) {SB_Name= _tempDetail.SB_Name;_UPDATE_SQL.Append("SB_Name='"+SB_Name+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_XingHao)) {SB_XingHao= _tempDetail.SB_XingHao;_UPDATE_SQL.Append("SB_XingHao='"+SB_XingHao+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_JingDu)) {SB_JingDu= _tempDetail.SB_JingDu;_UPDATE_SQL.Append("SB_JingDu='"+SB_JingDu+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_ShuLiang)) {SB_ShuLiang= _tempDetail.SB_ShuLiang;_UPDATE_SQL.Append("SB_ShuLiang='"+SB_ShuLiang+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_ZhuangTai)) {SB_ZhuangTai= _tempDetail.SB_ZhuangTai;_UPDATE_SQL.Append("SB_ZhuangTai='"+SB_ZhuangTai+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.SB_DeleteFlag)) {SB_DeleteFlag= _tempDetail.SB_DeleteFlag;_UPDATE_SQL.Append("SB_DeleteFlag='0'");}


            //_UPDATE_SQL.Remove(_UPDATE_SQL.Length - 1, 1);
            _UPDATE_SQL.Append("where SB_ID ='" + SB_ID + "'");


            string _SELECT_SQL = "select count(*) from [AnBiaoDanWeiSheBei] where SB_ID ='"+SB_ID+"'";
            //return _SELECT_SQL;

            int _SelectCount =Convert.ToInt16( Class1.GetSqlResult(_SELECT_SQL));
            _tempString +=  _SelectCount + "????" + _SELECT_SQL;
            if (_SelectCount == 0)
            {
                string _INSERST_SQL = @"insert into AnBiaoDanWeiSheBei([SB_PS_ID]
      ,[SB_Type]
      ,[SB_Name]
      ,[SB_XingHao]
      ,[SB_JingDu]
      ,[SB_ShuLiang]
      ,[SB_ZhuangTai]
      ,[SB_EditTime]
      ,[SB_BianHao]
      ,[SB_DeleteFlag]
      ,[SB_AddTime]) values('" +SB_PS_ID+"','"+
    SB_Type+"','"+
    SB_Name+"','"+
    SB_XingHao+"','"+
    SB_JingDu+"','"+
    SB_ShuLiang+"','"+
    SB_ZhuangTai+"','"+
    timeNow+"','"+
    SB_BianHao+"','"+
    "0','"+ timeNow+"')";
                int _InsertCount = Convert.ToInt16(Class1.ExecCommand(_INSERST_SQL));

                if (_InsertCount > 0)
                {
                    _tempString =  "{msg:'添加成功！'}";
                }
                else
                    _tempString = "{msg:'添加失败！'}";

            }
            else {
                //_tempString += _UPDATE_SQL + "????" ;

                string _tt= Class1.GetSqlResult(_UPDATE_SQL.ToString());
                _tempString = "{msg:'修改成功！'}";

            }
        }
        return _tempString.ToString();

    }
    public string deleteDanWeiSheBei(HttpContext context)
    {//一个参数ids
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string idsArray = json.Split(':')[1].ToString();
        StringBuilder jsonString = new StringBuilder("update   [AnBiaoDanWeiSheBei] set SB_DeleteFlag='1',");
        jsonString.Append("SB_EditTime ='" +  DateTime.Now.ToString("yyyyMMddHHmmss") + "'     ");
        StringBuilder TempString = new StringBuilder();
        List<string> _tempArray = new List<string>();
        string _tempIds = "";
        if (idsArray.IndexOf(',') != -1)
        {
            string[] _tempArr = idsArray.Split(',');
            for (int t = 0; t < _tempArr.Length; t++)
                _tempIds+="'" + _tempArr[t] + "',";
            string __tempIds = _tempIds.Substring(0, _tempIds.Length - 1);
            jsonString.Append("   where SB_ID in ("+__tempIds+")");

        }
        else
            jsonString.Append("where SB_ID in ('"+idsArray+"')");
        int _InsertCount = Convert.ToInt16(Class1.ExecCommand(jsonString.ToString()));

        if (_InsertCount > 0)
        {
            _tempString = "{msg:'删除成功！'}";
        }
        else
            _tempString = "{msg:'删除失败！'}";
        return _tempString;
    }
    # endregion
    #region 任务编辑 
    public string saveRenWuDetail(HttpContext context)
    {

        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd();
        _temp _temp_jo = JsonConvert.DeserializeObject<_temp>(json);//反序列化;

        string ids = _temp_jo.ids;//反序列化;
        string PS_XiangMu = _temp_jo.PS_XiangMu;//反序列化;
        string _tempSring = _temp_jo.postObj.ToString();//反序列化;

        if (ids != "")
        {
            string _tempSql = "update AnBiaoPingShen set PS_Detail ='" + _tempSring + "',PS_XiangMu='"+PS_XiangMu+ "' where PS_ID='" + ids + "'";
            Class1.ExecSql(_tempSql);
        }
        return
                "保存成功";
    }
    public string getRenWuDetail(HttpContext context)
    //查询所有单位人员信息，key为单位任务编号RY_PS_ID
    {
        string PS_ID = "";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{", "").Replace("}", "").Replace("\"", "");
        string[] jsonArray = json.Split(':');
        if (jsonArray[1].ToString().Trim() != "")
        {
            StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoPingShen] where PS_DeleteFlag ='0'");
            StringBuilder querySql = new StringBuilder("select  [id]      ,[PS_ID]      ,[PS_DanWei]      ,[PS_RiQiStart]      ,[PS_RiQiEnd]      ,[PS_Detail]      ,[PS_JieLun] ,[PS_File],[PS_Type],[PS_XiangMu]  from [AnBiaoPingShen] where PS_DeleteFlag ='0'");

            querySql.Append("  and  PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");
            querySql.Append("  order by PS_ID asc");
            queryCountSql.Append("  and  PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");

            int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));
            List<GetRenWu> jsonResult = new List<GetRenWu>();
            IDataReader reader = Class1.GetDataReader(querySql.ToString());
            StringBuilder jsonString = new StringBuilder();
            jsonString.Append("{\"count\":"+SqlCount);
            jsonString.Append(",\"Data\":");
            string jso = "";
            if (SqlCount == 0)
            {
                jsonString.Append("}");
                jso = jsonString.ToString();
            }
            else
            {
                jsonString.Append("[");

                while (reader.Read())
                {
                    jsonString.Append("{");
                    jsonString.AppendFormat("\"id\":\"{0}\"", reader["id"].ToString());
                    jsonString.AppendFormat(",\"PS_ID\":\"{0}\"", reader["PS_ID"].ToString());
                    jsonString.AppendFormat(",\"PS_DanWei\":\"{0}\"", reader["PS_DanWei"].ToString());
                    jsonString.AppendFormat(",\"PS_RiQiStart\":\"{0}\"", reader["PS_RiQiStart"].ToString());
                    jsonString.AppendFormat(",\"PS_RiQiEnd\":\"{0}\"", reader["PS_RiQiEnd"].ToString());
                    jsonString.AppendFormat(",\"PS_JieLun\":\"{0}\"", reader["PS_JieLun"].ToString());
                    jsonString.AppendFormat(",\"PS_Detail\":{0}", reader["PS_Detail"].ToString());
                    jsonString.AppendFormat(",\"PS_XiangMu\":\"{0}\"", reader["PS_XiangMu"].ToString());
                    jsonString.AppendFormat(",\"PS_File\":\"{0}\"", reader["PS_File"].ToString());
                    jsonString.AppendFormat(",\"PS_Type\":\"{0}\"", reader["PS_Type"].ToString());
                    jsonString.Append("},");
                    //json.AddItem("id", reader["id"].ToString());
                    //json.AddItem("name", reader["GS_JieGou"].ToString());
                    //json.AddItem("sex", reader["GS_SJDanWei"].ToString());
                    //json.ItemOk();

                }

                jso = jsonString.ToString().Substring(0, jsonString.ToString().Length - 1);

                jso += "]";
                reader.Close();
                jso += "}";
            }
            return jso.ToString();

        }
        else
            return "请选择PS_ID";

    }
    #endregion

    public class DANWEIRENYUAN {

        public string RY_ID {get;set;}
        public string RY_PS_ID {get;set;}
        public string RY_UserName {get;set;}
        public string RY_XingBie {get;set;}
        public string RY_Birthday {get;set;}
        public string RY_XueLi {get;set;}
        public string RY_ZhuanYie {get;set;}
        public string RY_ZhiWu {get;set;}
        public string RY_Phone {get;set;}
        public string RY_Tel {get;set;}
        public string RY_RuZhiTime {get;set;}
        public string RY_CongYeTime {get;set;}
        public string RY_HeTong {get;set;}
        public string RY_EditTIme {get;set;}
        public string RY_AddTIme {get;set;}
        public string RY_DeleteFlag {get;set;}
        public string RY_ZhiCheng {get;set;}
    }
    public string deleteDanWeiRenYuan(HttpContext context)
    {
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string idsArray = json.Split(':')[1].ToString();
        StringBuilder jsonString = new StringBuilder("update   [AnBiaoDanWeiRenYuan] set RY_DeleteFlag='1',");
        jsonString.Append("RY_EditTime ='" +  DateTime.Now.ToString("yyyyMMddHHmmss") + "'     ");
        StringBuilder TempString = new StringBuilder();
        List<string> _tempArray = new List<string>();
        string _tempIds = "";
        if (idsArray.IndexOf(',') != -1)
        {
            string[] _tempArr = idsArray.Split(',');
            for (int t = 0; t < _tempArr.Length; t++)
                _tempIds+="'" + _tempArr[t] + "',";
            string __tempIds = _tempIds.Substring(0, _tempIds.Length - 1);
            jsonString.Append("   where RY_ID in ("+__tempIds+")");

        }
        else
            jsonString.Append("where RY_ID in ('"+idsArray+"')");
        int _InsertCount = Convert.ToInt16(Class1.ExecCommand(jsonString.ToString()));

        if (_InsertCount > 0)
        {
            _tempString = "{msg:'删除成功！'}";
        }
        else
            _tempString = "{msg:'删除失败！'}";
        return _tempString;
    }
    public string editDanWeiRenYuan(HttpContext context)
    {
        string RY_ID ="";
        string RY_PS_ID ="";
        string RY_UserName ="";
        string RY_XingBie ="";
        string RY_Birthday ="";
        string RY_XueLi ="";
        string RY_ZhuanYie ="";
        string RY_ZhiWu ="";
        string RY_Phone ="";
        string RY_Tel ="";
        string RY_RuZhiTime ="";
        string RY_CongYeTime ="";
        string RY_HeTong ="";
        string RY_EditTIme ="";
        string RY_AddTIme ="";
        string RY_DeleteFlag ="";
        string RY_ZhiCheng ="";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd();
        var _tempObj = JsonConvert.DeserializeObject<Object>(json);//反序列化;

        DANWEIRENYUAN _tempDetail = JsonConvert.DeserializeObject<DANWEIRENYUAN>(json);//反序列化;
        string sql = "";
        string timeNow = DateTime.Now.ToString("yyyyMMddHHmmss");
        StringBuilder _UPDATE_SQL = new StringBuilder("update [AnBiaoDanWeiRenYuan] set ");
        _UPDATE_SQL.Append("RY_EditTime ='" + timeNow+ "',");
        if (_tempDetail != null) {
            if(!string.IsNullOrEmpty(_tempDetail.RY_ID)) {RY_ID= _tempDetail.RY_ID;}
            if(!string.IsNullOrEmpty(_tempDetail.RY_PS_ID)) {RY_PS_ID= _tempDetail.RY_PS_ID;_UPDATE_SQL.Append("RY_PS_ID='"+RY_PS_ID+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_UserName)) {RY_UserName= _tempDetail.RY_UserName;_UPDATE_SQL.Append("RY_UserName='"+RY_UserName+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_XingBie)) {RY_XingBie= _tempDetail.RY_XingBie;_UPDATE_SQL.Append("RY_XingBie='"+RY_XingBie+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_Birthday)) {RY_Birthday= _tempDetail.RY_Birthday;_UPDATE_SQL.Append("RY_Birthday='"+RY_Birthday+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_XueLi)) {RY_XueLi= _tempDetail.RY_XueLi;_UPDATE_SQL.Append("RY_XueLi='"+RY_XueLi+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_ZhuanYie)) {RY_ZhuanYie= _tempDetail.RY_ZhuanYie;_UPDATE_SQL.Append("RY_ZhuanYie='"+RY_ZhuanYie+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_ZhiWu)) {RY_ZhiWu= _tempDetail.RY_ZhiWu;_UPDATE_SQL.Append("RY_ZhiWu='"+RY_ZhiWu+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_Phone)) {RY_Phone= _tempDetail.RY_Phone;_UPDATE_SQL.Append("RY_Phone='"+RY_Phone+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_Tel)) {RY_Tel= _tempDetail.RY_Tel;_UPDATE_SQL.Append("RY_Tel='"+RY_Tel+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_RuZhiTime)) {RY_RuZhiTime= _tempDetail.RY_RuZhiTime;_UPDATE_SQL.Append("RY_RuZhiTime='"+RY_RuZhiTime+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_CongYeTime)) {RY_CongYeTime= _tempDetail.RY_CongYeTime;_UPDATE_SQL.Append("RY_CongYeTime='"+RY_CongYeTime+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_HeTong)) {RY_HeTong= _tempDetail.RY_HeTong;_UPDATE_SQL.Append("RY_HeTong='"+RY_HeTong+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_DeleteFlag)) {RY_DeleteFlag= _tempDetail.RY_DeleteFlag;_UPDATE_SQL.Append("RY_DeleteFlag='"+RY_DeleteFlag+"',");}
            if(!string.IsNullOrEmpty(_tempDetail.RY_ZhiCheng)) {RY_ZhiCheng= _tempDetail.RY_ZhiCheng;_UPDATE_SQL.Append("RY_ZhiCheng='"+RY_ZhiCheng+"',");}
        }
        _UPDATE_SQL.Remove(_UPDATE_SQL.Length - 1, 1);
        _UPDATE_SQL.Append("where RY_ID ='" + RY_ID + "'");


        string _SELECT_SQL = "select count(*) from [AnBiaoDanWeiRenYuan] where RY_ID ='"+RY_ID+"'";
        int _SelectCount =Convert.ToInt16( Class1.GetSqlResult(_SELECT_SQL));
        _tempString +=  _SelectCount + "????" + _SELECT_SQL;
        if (_SelectCount == 0)
        {
            string _INSERST_SQL = @"insert into AnBiaoDanWeiRenYuan([RY_PS_ID]
                              ,[RY_UserName]
                              ,[RY_XingBie]
                              ,[RY_Birthday]
                              ,[RY_XueLi]
                              ,[RY_ZhuanYie]
                              ,[RY_ZhiWu]
                              ,[RY_Phone]
                              ,[RY_Tel]
                              ,[RY_RuZhiTime]
                              ,[RY_CongYeTime]
                              ,[RY_HeTong]
                              ,[RY_AddTIme] 
                              ,[RY_EditTIme]
                              ,[RY_ZhiCheng]
                              ,[RY_DeleteFlag]) values('" + RY_PS_ID+"','" + RY_UserName+"','"+
                        RY_XingBie+"','"+
                        RY_Birthday+"','"+
                        RY_XueLi+"','"+
                        RY_ZhuanYie+"','"+
                        RY_ZhiWu+"','"+
                        RY_Phone+"','"+
                        RY_Tel+"','"+
                        RY_RuZhiTime+"','"+
                        RY_CongYeTime+"','"+
                        RY_HeTong+"','"+
                       timeNow +"','"+
                       timeNow +"','"+
                        RY_ZhiCheng+"','0')";
            int _InsertCount = Convert.ToInt16(Class1.ExecCommand(_INSERST_SQL));

            if (_InsertCount > 0)
            {
                _tempString =  "{msg:'添加成功！'}";
            }
            else
                _tempString = "{msg:'添加失败！'}";

        }
        else {
            //_tempString += _UPDATE_SQL + "????" ;

            string _tt= Class1.GetSqlResult(_UPDATE_SQL.ToString());
            _tempString = "{msg:'修改成功！'}";





        }

        return _tempString.ToString();


    }

    public Document delteRows(Document  doc,int[] _xiangmu_, string _name)
    {
        //string templetFile = templetFilePath + "anbiao.docx";
        //Document doc = new Document(templetFile);  /* 建立Document物件 */
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
                                                              /* Quick typed access to the first child Section node of the Document. */
        Section section = doc.FirstSection;

        /* Quick typed access to the Body child node of the Section. */
        Body body = section.Body;

        /* Quick typed access to all Table child nodes contained in the Body. */
        TableCollection tables = body.Tables;
        Aspose.Words.Tables.Table table = tables[0];

        if(_name.IndexOf("jilu")!=-1)
            table = tables[1];

        Cell cell = table.Rows[1].Cells[0];
        // cell.RemoveAllChildren();
        //builder.MoveToCell(0, 1,0, 0);
        int[] xuhao = new int[13] { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 };//序号
        int[] hebingIndex = new int[19] { 6, 9, 15, 18, 23, 26, 29, 32, 37, 42, 46, 53, 62, 66, 75, 78, 81, 93, 109 };//需要合并的序号
        int[] hebingTableIndex = new int[19] { 5, 7, 12, 14, 18, 20, 22, 24, 28, 32, 35, 41, 49, 52, 60, 62, 64, 74, 89 };//需要合并的序号
        List<int> _hebing_xiangmu = new List<int>();//需要保留的table里面的数组的Index
                                                    //_hebing_xiangmu = hebingTableIndex.ToList();
        List<int> _hebing_rows = new List<int>();//需要保留的table里面的数组的Index
        int[] daLei = new int[12] { 1, 4, 13, 21, 35, 44, 60, 72, 96, 102, 106, 112 };//大类的序号
        int[] daLeiRow = new int[] { 1, 4, 11, 17, 27, 34, 48, 58, 77, 83, 87, 92};//大类的序号
        int[] _delteDaLei = new int[12] { 1, 4, 13, 21, 35, 44, 60, 72, 96, 102, 106, 112 };//需要删除的大类的序号
        int[] _delIndex = new int[] {  0,4, 11, 17, 27, 34, 48, 58, 77, 83, 87, 92, 95, 96 };//需要删除的大类的序号，大于等于而小于
        int[] tableIndex = new int[14] { 0, 4, 11, 17, 27, 34, 48, 58, 77, 83, 87, 92, 95, 96 };//大类对应的表格里的序号
        int[] zhijiesanChuIndex = new int[] { 7, 10, 11, 12, 16, 19, 24, 27, 30, 33, 38, 39, 40, 43, 47, 48, 49, 50, 51, 54, 55, 56, 57, 58, 59, 63, 64, 67, 68, 69, 70, 71, 76, 79, 82, 83, 84, 87, 88, 89, 90, 91, 94, 110 };//可直接删除的表格序号
        int[] zhijiesanChuRow = new int[] { 6, 8, 9, 10, 13, 15, 19, 21, 23, 25, 29, 30, 31, 33, 36, 37, 38, 39, 40, 42, 43, 44, 45, 45, 47, 50, 51, 53, 54, 55, 56, 57, 61, 63, 65, 66, 67, 69, 70, 71, 72, 73, 75, 90 };
        int[] allXiangmu = new int[] { 0,1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115 };//可直接删除的 
        int[] allRow = new int[] { 0,1, 2, 3, 4, 5, 5, 6, 7, 7, 8, 9, 10, 11, 12, 12, 13, 14, 14, 15, 16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 24, 24, 25, 26, 27, 28, 28, 29, 30, 31, 32, 32, 33, 34, 35, 35, 36, 37, 38, 39, 40, 41, 41, 42, 43, 44, 45, 46, 47, 48, 49, 49, 50, 51, 52, 52, 53, 54, 55, 56, 57, 58, 59, 60, 60, 61, 62, 62, 63, 64, 64, 65, 66, 67, 68, 69, 69, 70, 71, 72, 73, 74, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 89, 90, 91, 92, 93, 94, 95 };//可直接删除的表格序号
        int[] erji = new int[40] { 2, 3, 5, 8, 14, 17, 20, 22, 25, 28, 31, 34, 36, 41, 45, 52, 61, 65, 73, 74, 77, 80, 85, 86, 92, 95, 97, 98, 99, 100, 101, 103, 104, 105, 107, 108, 111, 113, 114, 115 };
        int[] erji_Row = new int[40] { 2, 3, 5, 7, 12, 14, 16, 18, 20, 22, 24, 26, 28, 32, 35, 41, 49, 52, 59, 60, 62, 64, 68, 69, 74, 76, 78, 79, 80, 81, 82, 84, 85, 86, 88, 89, 91, 93, 94, 95 };
        int[] erji_Row_count = new int[40] { 0, 0, 2, 4, 2, 2, 0, 2, 2, 2, 2, 0, 4, 2, 6, 7, 3, 6, 0, 2, 2, 4, 0, 5, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0 };
        List<int> erJisanChuIndex_rows = new List<int>();//需要保留的table里面的数组的Index
        List<int> _erJisanChuIndex = new List<int>();//需要保留的table里面的数组的Index

        List<int> _zhijiesanChu_rows = new List<int>();//需要保留的table里面的数组的Index
        List<int> _zhijiesanChuIndex = new List<int>();//需要保留的table里面的数组的Index
        List<int> baoliu_xiangmu = new List<int>();//需要保留的table里面的大类Index
        List<int> delete_xiangmu = xuhao.ToList();//需要删除的table里面的数组的Index
        List<int> delete_rows = new List<int>();//需要保留的table里面的数组的Index
        List<int> baoliu_rows = new List<int>();//需要保留的table里面的数组的Index
        List<int> _delete_xiangmu = new List<int>();//需要保留的table里面的数组的Index

        //int[] _xiangmu_ = new int[] { 1, 2, 3, 35, 36, 37, 38, 39, 40, 41, 42, 43 };
        //int[] _xiangmu_ = new int[] { 1, 2, 3, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 52, 53, 54, 55, 56, 57, 58, 59 };
        //int[] _xiangmu_ = new int[] {1,2,3,21,28,30,34,35,36,37,40,44,52,53,54,55,56,57,58,59,60,61,62,64,65,66,67};

        _xiangmu_.ToList().Sort();

        ///doc文件中所有的ROW
        builder.MoveToDocumentEnd();
        int[] allRow_0 = allRow.Distinct().ToArray();
        //builder.Write("所有ROW：" + String.Join(",", allRow_0) + "\n");

        ///评审任务中选定的ROW
        int[] xiangmuRow = new int[] { };
        List<int> _xiangmuRow = new List<int>() { };
        for (int t = 0; t < _xiangmu_.Length; t++)
            _xiangmuRow.Add(allRow[_xiangmu_[t]]);

        xiangmuRow = _xiangmuRow.ToArray();
        xiangmuRow = xiangmuRow.Distinct().ToArray();
        //builder.MoveToDocumentEnd();
        //builder.Write("项目ROW：" + String.Join(",", xiangmuRow) + "\n");

        ///需要删除的ROW
        ///先找到项目编号中没有的项，再找到对应的ROW
        var  _temp_arr_1  = allXiangmu.Except(_xiangmu_);
        List<int> _sanchuId = _temp_arr_1.ToList();
        List<int> _sanchu_Row = new List<int>();
        for (int m = 0; m < _sanchuId.Count; m++)
        {
            int _temp = _sanchuId[m];
            if (_temp!=0)
                _sanchu_Row.Add(allRow[_temp]);
        }
        //builder.MoveToDocumentEnd();
        //builder.Write("删除项目ROW：" + String.Join(",", _sanchu_Row) + "\n");


        var sanChuXiangmuRow = _sanchu_Row; //差集 { 1, 2 }
        List<int> _sanChuXiangmuRow_list= sanChuXiangmuRow.ToList();
        //builder.Write("删除Row：" + String.Join(",", sanChuXiangmuRow) + "\n");

        //int[] _Tee = sanChuXiangmu.ToArray();
        //List<int> _Tdd = new List<int>() { };
        //for (int i = 0; i < _Tee.Length; i++)
        //    _Tdd.Add(allRow[_Tee[i]]);

        //builder.Write("删除Row-111：" + String.Join(",", _Tdd) + "\n");
        //var sanChuR = allXiangmu.Except(_xiangmu_); //差集 { 1, 2 }
        //builder.Write("删除Row：" + String.Join(",", sanChuXiangmu) + "\n");
        //List<int> sanChuRows = new List<int> { };
        //int[] _tempArray_1 = sanChuXiangmu.ToArray();
        //for (int t = 0; t < _tempArray_1.Length; t++)
        //    sanChuRows.Add(allRow[_tempArray_1[t]]);
        //int[] _sanChuRows = sanChuRows.ToArray();
        //_sanChuRows = _sanChuRows.Distinct().ToArray();
        //List<int> xiangmu = new List<int>();
        //xiangmu = _xiangmu_.ToList();
        //int[] _xiangmu = xiangmu.ToArray();

        //var _sanChuRows_= allRow_0.Except(xiangmuRow);
        //List<int> sanChuRows_ = new List<int> { };
        //builder.MoveToDocumentEnd();
        //builder.Write("要删除的项目Row：" + String.Join(",", _sanChuRows_) + "\n");

        #region 如果删除项目中有一级大类，则将大类及所包含的小项目删除,可以于整行删除大类       
        for (int t = 0; t < daLeiRow.Length; t++)
        {
            //如果删除项目中有大类      
            int _temXiangmu = daLeiRow[t];
            int _tmpId = sanChuXiangmuRow.ToList().IndexOf(_temXiangmu);
            if (_tmpId != -1)
            {

                builder.MoveToDocumentEnd();
                //builder.Write("删除大类：" + _temXiangmu + "|" + _tmpId + "\n");
                int tem_0 = daLeiRow[t];
                int tem_1 = 0;
                if (t == 11)
                    tem_1 = 96;
                else
                    tem_1 = daLeiRow[t + 1];
                for (int j = tem_0; j < tem_1; j++)
                {
                    delete_rows.Add(j);
                    //builder.Write("删除：" + j + "|" + "\n");

                }

            }
            else
            {
                builder.MoveToDocumentEnd();
                //builder.Write("删除大类：" + _temXiangmu + "|" + _tmpId + "\n");
            }
        }
        //builder.Write("删除大类：" +String.Join(",", sanChuXiangmuRow)  + "\n");

        ///可以整行删除的项目
        delete_rows.Sort();
        delete_rows.Reverse();
        //builder.MoveToDocumentEnd();
        //builder.Write("大类删除项目：" + String.Join(",", delete_rows) + "\n");

        #endregion
        #region 如果没有二级大类，

        var _arr_1 = sanChuXiangmuRow.Except(delete_rows);
        List<int> _erjiXiangmuRow_list = _arr_1.ToList();
        builder.MoveToDocumentEnd();
        //builder.Write("大类删除后：" + String.Join(",", _erjiXiangmuRow_list) + "\n");
        for (int t = 0; t < 40; t++)
        {
            //如果删除项目中有二级大类      
            int _temXiangmu = erji[t];
            int _tmpId = _arr_1.ToList().IndexOf(_temXiangmu);
            if (_tmpId != -1)    //如果项目中有二级类  
            {

                if (erji_Row_count[t] == 0)
                    erJisanChuIndex_rows.Add(erji_Row[t]);
                else
                {
                    for (int j = 0; j < erji_Row_count[t]; j++)
                    {
                        erJisanChuIndex_rows.Add(erji_Row[t] + j);
                    }
                }
            }
        }
        erJisanChuIndex_rows.Sort();
        erJisanChuIndex_rows.Reverse();
        builder.MoveToDocumentEnd();
        //builder.Write("二类删除项目：" + String.Join(",", erJisanChuIndex_rows) + "\n");
        #endregion

        #region 如果包含可以直接删除的三级项目
        var _arr_2 = _arr_1.Except(erJisanChuIndex_rows);
        List<int> _sanjiXiangmuRow_list = _arr_2.ToList();
        builder.MoveToDocumentEnd();
        //builder.Write("二类删除后：" + String.Join(",", _sanjiXiangmuRow_list) + "\n");

        for (int t = 0; t < zhijiesanChuIndex.Length; t++)
        {
            if (_sanjiXiangmuRow_list.IndexOf(zhijiesanChuIndex[t]) != -1)    //如果项目中包含可以直接删除项     
                _zhijiesanChu_rows.Add(zhijiesanChuRow[t]);//删除的index                    
        }
        _zhijiesanChu_rows.Sort();
        _zhijiesanChu_rows.Reverse();
        builder.MoveToDocumentEnd();
        //builder.Write("三类删除项目：" + String.Join(",", _zhijiesanChu_rows) + "\n");
        #endregion
        #region 如果需要合并的项目中没有项目序号，则将表格中的内容清空
        var _arr_3 = _arr_2.Except(_zhijiesanChu_rows);
        List<int> _sijiXiangmuRow_list = _arr_3.ToList();
        builder.MoveToDocumentEnd();
        builder.Write("三类删除后：" + String.Join(",", _zhijiesanChu_rows) + "\n");
        for (int t = 0; t < hebingIndex.Length; t++)
        {
            if (_sijiXiangmuRow_list.IndexOf(hebingIndex[t]) == -1)    //如果项目中没有大类      
            {
                //_delete_xiangmu.Add(t);//删除的index   
                _hebing_rows.Add(hebingTableIndex[t]);
            }
        }

        _hebing_rows.Sort();
        _hebing_rows.Reverse();
        builder.MoveToDocumentEnd();
        //builder.Write("需要合并项目：：" + String.Join(",", _hebing_rows) + "\n");
        #endregion
        var _arr_4 = _arr_3.Except(_hebing_rows);
        List<int> _shengyuXiangmuRow_list = _arr_4.ToList();
        builder.MoveToDocumentEnd();
        //builder.Write("全部删除后：" + String.Join(",", _shengyuXiangmuRow_list) + "\n");
        List<int> _san_Row = sanChuXiangmuRow;
        _san_Row = _san_Row.Distinct().ToList();
        _san_Row.Sort();
        _san_Row.Reverse();
        //builder.Write("----------------" + String.Join(",",_san_Row) + "\n");
        int d = table.Rows.Count;
        for (int m = 0; m < _san_Row.Count; m++)
        {
            Row row = table.Rows[_san_Row[m]];
            //builder.Write("------删除第几行----------" + _san_Row[m] + "\n");
            row.Remove();
            // deletCounts++;
        }
        return doc;


    }
    #region 对Word中某一个表格格式进行修改 
    private static Aspose.Words.Tables.Table EditCell_0 (Aspose.Words.Tables.Table table, Document doc, int row, int cell, string value,bool flag)
    {
        Cell c = table.Rows[row].Cells[cell];
        Paragraph p = new Paragraph(doc);
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        Run r = new Run(doc, value);
        r.Font.Name = "字体";
        r.Font.Size = 11;//字号
        r.Font.Bold = true;    //加粗                      
        p.ParagraphFormat.Alignment = ParagraphAlignment.Center; //水平居中
        p.AppendChild(r);
        // table.Rows[row].Cells[cell].Remove();
        if (flag) {
            if (c.HasChildNodes)
            {
                foreach(Node n in c.ChildNodes)
                {
                    /// c.RemoveChild(n);   
                    builder.MoveToDocumentStart();
                    builder.Write(n.ToString());
                    builder.Write(n.NodeType.ToString());
                }
            }
        }
        //p.AppendChild(r);
        table.Rows[row].Cells[cell].AppendChild(p);
        //builder.InsertCell();
        //builder.Write("Row 2, Col 1");
        //table.Rows[row].Cells.Insert(cell, p);
        return table;
    }

    #endregion
    public class DETAILS
    {

        public string PS_ID {get;set;}
        public string PS_DanWei {get;set;}
        public string PS_DanWeiDiZhi {get;set;}
        public string PS_RenYuan {get;set;}
        public string PS_RiQiStart {get;set;}
        public string PS_RiQiEnd {get;set;}
        public string PS_Detail {get;set;}
        public string PS_RenWuShu {get;set;}
        public string PS_DanWeiJianJie {get;set;}
        public string PS_JieLun {get;set;}
        public string PS_BuHege {get;set;}
        public string PS_File {get;set;}
        public string PS_DanWeiRenYuan {get;set;}
        public string PS_DanWeiShengChan {get;set;}
        public string PS_DanWeiJianChe {get;set;}
        public string PS_XiangMu {get;set;}
        public string PS_Type {get;set;}
    }

    public class GetRenWu
    {
        public string PS_ID { get; set; }
        public string PS_DanWei { get; set; }
        public string PS_DanWeiDiZhi { get; set; }
        public string PS_RiQiStart { get; set; }
        public string PS_RiQiEnd { get; set; }
        public string PS_JieLun { get; set; }
        public string PS_RenYuan { get; set; }
        public string PS_XiangMu { get; set; }
        public string PS_Type { get; set; }


    }
    public string getDanWeiRenYuan(HttpContext context)
    //查询所有单位人员信息，key为单位任务编号RY_PS_ID
    {
        string PS_ID = "";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{", "").Replace("}", "").Replace("\"", "");
        string[] jsonArray = json.Split(':');
        if (jsonArray[1].ToString().Trim() != "")
        {
            StringBuilder queryCountSql = new StringBuilder("select count(*)  from [AnBiaoDanWeiRenYuan] where RY_DeleteFlag ='0'");
            StringBuilder querySql = new StringBuilder("select *  from [AnBiaoDanWeiRenYuan] where RY_DeleteFlag ='0'");

            querySql.Append("  and  RY_PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");
            querySql.Append("  order by RY_ID asc");
            queryCountSql.Append("  and  RY_PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");

            int SqlCount = Convert.ToInt16(Class1.ReturnValue(queryCountSql.ToString()));
            List<GetRenWu> jsonResult = new List<GetRenWu>();
            IDataReader reader = Class1.GetDataReader(querySql.ToString());
            StringBuilder jsonString = new StringBuilder();
            jsonString.Append("{\"count\":"+SqlCount);
            jsonString.Append(",\"Data\":[");
            string jso = "";
            if (SqlCount == 0)
            {
                jsonString.Append("]}");
                jso = jsonString.ToString();
            }
            else
            {

                while (reader.Read())
                {
                    jsonString.Append("{");
                    jsonString.AppendFormat("\"RY_ID\":\"{0}\"", reader["RY_ID"].ToString());
                    jsonString.AppendFormat(",\"RY_PS_ID\":\"{0}\"", reader["RY_PS_ID"].ToString());
                    jsonString.AppendFormat(",\"RY_UserName\":\"{0}\"", reader["RY_UserName"].ToString());
                    jsonString.AppendFormat(",\"RY_XingBie\":\"{0}\"", reader["RY_XingBie"].ToString());
                    jsonString.AppendFormat(",\"RY_Birthday\":\"{0}\"", reader["RY_Birthday"].ToString());
                    jsonString.AppendFormat(",\"RY_XueLi\":\"{0}\"", reader["RY_XueLi"].ToString());
                    jsonString.AppendFormat(",\"RY_ZhuanYie\":\"{0}\"", reader["RY_ZhuanYie"].ToString());
                    jsonString.AppendFormat(",\"RY_ZhiWu\":\"{0}\"", reader["RY_ZhiWu"].ToString());
                    jsonString.AppendFormat(",\"RY_Phone\":\"{0}\"", reader["RY_Phone"].ToString());
                    jsonString.AppendFormat(",\"RY_Tel\":\"{0}\"", reader["RY_Tel"].ToString());
                    jsonString.AppendFormat(",\"RY_RuZhiTime\":\"{0}\"", reader["RY_RuZhiTime"].ToString());
                    jsonString.AppendFormat(",\"RY_CongYeTime\":\"{0}\"", reader["RY_CongYeTime"].ToString());
                    jsonString.AppendFormat(",\"RY_HeTong\":\"{0}\"", reader["RY_HeTong"].ToString());
                    jsonString.AppendFormat(",\"RY_EditTIme\":\"{0}\"", reader["RY_EditTIme"].ToString());
                    jsonString.AppendFormat(",\"RY_AddTIme\":\"{0}\"", reader["RY_AddTIme"].ToString());
                    jsonString.AppendFormat(",\"RY_DeleteFlag\":\"{0}\"", reader["RY_DeleteFlag"].ToString());
                    jsonString.AppendFormat(",\"RY_ZhiCheng\":\"{0}\"", reader["RY_ZhiCheng"].ToString());
                    //jsonString.AppendFormat(",\"PS_XiangMu\":\"{0}\"", reader["PS_XiangMu"].ToString());
                    jsonString.Append("},");
                    //json.AddItem("id", reader["id"].ToString());
                    //json.AddItem("name", reader["GS_JieGou"].ToString());
                    //json.AddItem("sex", reader["GS_SJDanWei"].ToString());
                    //json.ItemOk();

                }

                jso = jsonString.ToString().Substring(0, jsonString.ToString().Length - 1);

                if (SqlCount == 0)
                    jso = jsonString.ToString();
                jso += "]";
                reader.Close();
                jso += "}";
            }
            return jso.ToString();

        }
        else
            return "请选择PS_ID";

    }

    public string getRenwuAll(HttpContext context)

    {
        string PS_ID ="";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string[] jsonArray = json.Split(':');
        StringBuilder queryCountSql = new StringBuilder( "select count(*)  from [AnBiaoPingShen] where PS_DeleteFlag ='0'");
        StringBuilder querySql = new StringBuilder( "select *  from [AnBiaoPingShen] where PS_DeleteFlag ='0'");
        if (jsonArray[1].ToString().Trim() != "")
        {
            querySql.Append("  and  PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");
            queryCountSql.Append("  and  PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");
        }
        int SqlCount = Convert.ToInt16( Class1.ReturnValue(queryCountSql.ToString()));
        List<GetRenWu> jsonResult = new List<GetRenWu>();
        IDataReader reader = Class1.GetDataReader(querySql.ToString());
        StringBuilder jsonString = new StringBuilder();
        jsonString.Append("{\"count\":"+SqlCount);
        jsonString.Append(",\"Data\":[");
        string jso = "";
        if (SqlCount == 0)
        {
            jsonString.Append("]}");
            jso = jsonString.ToString();
        }
        else
        {

            while (reader.Read())
            {
                jsonString.Append("{");
                jsonString.AppendFormat("\"PS_ID\":\"{0}\",\"PS_DanWei\":\"{1}\",\"PS_DanWeiDiZhi\":\"{2}\",\"PS_RiQiStart\":\"{3}\",\"PS_RiQiEnd\":\"{4}\",\"PS_JieLun\":\"{5}\",\"PS_RenYuan\":\"{6}\",\"PS_RenWuShu\":\"{7}\",\"PS_BuHege\":\"{8}\",\"PS_DanWeiRenYuan\":\"{9}\",\"PS_DanWeiShengChan\":\"{10}\",\"PS_DanWeiJianChe\":\"{11}\",\"PS_EditTime\":\"{12}\",\"PS_AddTime\":\"{13}\",\"PS_Detail\":{14},\"PS_XiangMu\":\"{15}\"", reader["PS_ID"].ToString(), reader["PS_DanWei"].ToString(), reader["PS_DanWeiDiZhi"].ToString(), reader["PS_RiQiStart"].ToString(), reader["PS_RiQiEnd"].ToString(), reader["PS_JieLun"].ToString(), reader["PS_RenYuan"].ToString(), reader["PS_RenWuShu"].ToString(), reader["PS_BuHege"].ToString(), reader["PS_DanWeiRenYuan"].ToString(), reader["PS_DanWeiShengChan"].ToString(), reader["PS_DanWeiJianChe"].ToString(), reader["PS_EditTime"].ToString(), reader["PS_AddTime"].ToString(), reader["PS_Detail"].ToString(), reader["PS_XiangMu"].ToString());
                jsonString.Append("},");
                //json.AddItem("id", reader["id"].ToString());
                //json.AddItem("name", reader["GS_JieGou"].ToString());
                //json.AddItem("sex", reader["GS_SJDanWei"].ToString());
                //json.ItemOk();

            }
            jso = jsonString.ToString().Substring(0, jsonString.ToString().Length - 1);

            if (SqlCount == 0)
                jso = jsonString.ToString();
            jso += "]";
            reader.Close();
            jso += "}";
        }
        return jso.ToString();
    }
    public string getRenwu(HttpContext context)

    {
        string PS_ID ="";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string[] jsonArray = json.Split(':');
        StringBuilder queryCountSql = new StringBuilder( "select count(*)  from [AnBiaoPingShen] where PS_DeleteFlag ='0'");
        StringBuilder querySql = new StringBuilder( "select PS_ID ,PS_DanWei ,[PS_DanWeiDiZhi],[PS_RiQiStart],[PS_RiQiEnd],[PS_JieLun],[PS_RenYuan] ,[PS_DanWeiJianJie] ,PS_Type ,[PS_File] ,PS_BuHegeBaoGao,[PS_RenWuShu],PS_XiangMu from [AnBiaoPingShen] where PS_DeleteFlag ='0'");
        if (jsonArray[1].ToString().Trim() != "")
        {
            querySql.Append("  and  PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");
            queryCountSql.Append("  and  PS_ID like '%" + jsonArray[1].ToString().Trim() + "%'");
        }
        int SqlCount = Convert.ToInt16( Class1.ReturnValue(queryCountSql.ToString()));
        List<GetRenWu> jsonResult = new List<GetRenWu>();
        IDataReader reader = Class1.GetDataReader(querySql.ToString());
        StringBuilder jsonString = new StringBuilder();
        jsonString.Append("{\"count\":"+SqlCount);
        jsonString.Append(",\"Data\":");
        string jso = "";
        if (SqlCount == 0)
        {
            jsonString.Append("}");
            jso = jsonString.ToString();
        }
        else
        {
            jsonString.Append("[");

            while (reader.Read())
            {
                jsonString.Append("{");
                jsonString.AppendFormat("\"PS_ID\":\"{0}\",\"PS_DanWei\":\"{1}\",\"PS_DanWeiDiZhi\":\"{2}\",\"PS_RiQiStart\":\"{3}\",\"PS_RiQiEnd\":\"{4}\",\"PS_JieLun\":\"{5}\",\"PS_RenYuan\":\"{6}\",\"PS_DanWeiJianJie\":\"{7}\",\"PS_File\":\"{8}\",\"PS_BuHegeBaoGao\":\"{9}\",\"PS_XiangMu\":\"{10}\",\"PS_RenWuShu\":\"{11}\",\"PS_Type\":\"{12}\"", reader["PS_ID"].ToString(), reader["PS_DanWei"].ToString(), reader["PS_DanWeiDiZhi"].ToString(), reader["PS_RiQiStart"].ToString(), reader["PS_RiQiEnd"].ToString(), reader["PS_JieLun"].ToString(), reader["PS_RenYuan"].ToString(), reader["PS_DanWeiJianJie"].ToString(), reader["PS_File"].ToString(), reader["PS_BuHegeBaoGao"].ToString(), reader["PS_XiangMu"].ToString(), reader["PS_RenWuShu"].ToString(), reader["PS_Type"].ToString());
                jsonString.Append("},");
                //json.AddItem("id", reader["id"].ToString());
                //json.AddItem("name", reader["GS_JieGou"].ToString());
                //json.AddItem("sex", reader["GS_SJDanWei"].ToString());
                //json.ItemOk();

            }
            jso = jsonString.ToString().Substring(0, jsonString.ToString().Length - 1);

            if (SqlCount == 0)
                jso = jsonString.ToString();
            jso+="]";

            reader.Close();
            jso += "}";
        }
        return jso.ToString();
    }
    public string delete(HttpContext context)
    {
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string idsArray = json.Split(':')[1].ToString();
        StringBuilder jsonString = new StringBuilder("update   [AnBiaoPingShen] set PS_DeleteFlag='1',");
        jsonString.Append("PS_EditTime ='" +  DateTime.Now.ToString("yyyyMMddHHmmss") + "'     ");
        StringBuilder TempString = new StringBuilder();
        List<string> _tempArray = new List<string>();
        string _tempIds = "";
        if (idsArray.IndexOf(',') != -1)
        {
            string[] _tempArr = idsArray.Split(',');
            for (int t = 0; t < _tempArr.Length; t++)
                _tempIds+="'" + _tempArr[t] + "',";
            string __tempIds = _tempIds.Substring(0, _tempIds.Length - 1);
            jsonString.Append("   where PS_ID in ("+__tempIds+")");

        }
        else
            jsonString.Append("where PS_ID in ('"+idsArray+"')");
        int _InsertCount = Convert.ToInt16(Class1.ExecCommand(jsonString.ToString()));

        if (_InsertCount > 0)
        {
            _tempString = "{msg:'删除成功！'}";
        }
        else
            _tempString = "{msg:'删除失败！'}";
        return _tempString;
    }
    public string edit(HttpContext context)
    {
        string PS_ID ="";
        string PS_DanWei ="";
        string PS_DanWeiDiZhi ="";
        string PS_RenYuan ="";
        string PS_RiQiStart ="";
        string PS_RiQiEnd ="";
        string PS_Detail ="";
        string PS_RenWuShu ="";
        string PS_DanWeiJianJie ="";
        string PS_JieLun ="";
        string PS_BuHege ="";
        string PS_File ="";
        string PS_DanWeiRenYuan ="";
        string PS_DanWeiShengChan ="";
        string PS_DanWeiJianChe ="";
        string PS_XiangMu ="";
        string PS_Type ="";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd();
        var _tempObj = JsonConvert.DeserializeObject<Object>(json);//反序列化;

        DETAILS _tempDetail = JsonConvert.DeserializeObject<DETAILS>(json);//反序列化;
        string sql = "";



        StringBuilder _UPDATE_SQL = new StringBuilder("update AnBiaoPingShen set ");
        _UPDATE_SQL.Append("PS_EditTime ='" +  DateTime.Now.ToString("yyyyMMddHHmmss") + "',");
        if (_tempDetail != null) {
            if (!string.IsNullOrEmpty(_tempDetail.PS_ID)) { PS_ID = _tempDetail.PS_ID; _UPDATE_SQL.Append("PS_ID ='" + PS_ID + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_DanWei)) {PS_DanWei= _tempDetail.PS_DanWei;_UPDATE_SQL.Append("PS_DanWei ='" +PS_DanWei + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_DanWeiDiZhi)) {PS_DanWeiDiZhi= _tempDetail.PS_DanWeiDiZhi;_UPDATE_SQL.Append("PS_DanWeiDiZhi ='" +PS_DanWeiDiZhi + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_RenYuan)) {PS_RenYuan= _tempDetail.PS_RenYuan;_UPDATE_SQL.Append("PS_RenYuan ='" +PS_RenYuan + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_RiQiStart)) {PS_RiQiStart= _tempDetail.PS_RiQiStart;_UPDATE_SQL.Append("PS_RiQiStart ='" +PS_RiQiStart + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_RiQiEnd)) {PS_RiQiEnd= _tempDetail.PS_RiQiEnd;_UPDATE_SQL.Append("PS_RiQiEnd ='" +PS_RiQiEnd + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_Detail)) {PS_Detail= _tempDetail.PS_Detail;_UPDATE_SQL.Append("PS_Detail ='" +PS_Detail + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_XiangMu)) {PS_XiangMu= _tempDetail.PS_XiangMu;_UPDATE_SQL.Append("PS_XiangMu ='" +PS_XiangMu + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_RenWuShu)) {PS_RenWuShu= _tempDetail.PS_RenWuShu;_UPDATE_SQL.Append("PS_RenWuShu ='" +PS_RenWuShu + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_DanWeiJianJie)) {PS_DanWeiJianJie= _tempDetail.PS_DanWeiJianJie;_UPDATE_SQL.Append("PS_DanWeiJianJie ='" +PS_DanWeiJianJie + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_JieLun)) {PS_JieLun= _tempDetail.PS_JieLun;_UPDATE_SQL.Append("PS_JieLun ='" +PS_JieLun + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_Type)) {PS_Type= _tempDetail.PS_Type;_UPDATE_SQL.Append("PS_Type ='" +PS_Type + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_BuHege)) {PS_BuHege= _tempDetail.PS_BuHege;_UPDATE_SQL.Append("PS_BuHege ='" +PS_BuHege + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_File)) {PS_File= _tempDetail.PS_File;_UPDATE_SQL.Append("PS_File ='" +PS_File + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_DanWeiRenYuan)) {PS_DanWeiRenYuan= _tempDetail.PS_DanWeiRenYuan;
                _UPDATE_SQL.Append("PS_DanWeiRenYuan ='" +PS_DanWeiRenYuan + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_DanWeiShengChan)) {PS_DanWeiShengChan= _tempDetail.PS_DanWeiShengChan;_UPDATE_SQL.Append("PS_DanWeiShengChan ='" +PS_DanWeiShengChan + "',"); }
            if(!string.IsNullOrEmpty(_tempDetail.PS_DanWeiJianChe)) {PS_DanWeiJianChe= _tempDetail.PS_DanWeiJianChe;_UPDATE_SQL.Append("PS_DanWeiJianChe ='" +PS_DanWeiJianChe + "',"); }
            _UPDATE_SQL.Remove(_UPDATE_SQL.Length - 1, 1);
            _UPDATE_SQL.Append("where PS_ID ='" + PS_ID + "'");


            string _SELECT_SQL = "select count(*) from AnBiaoPingShen where PS_ID ='"+PS_ID+"'";
            int _SelectCount =Convert.ToInt16( Class1.GetSqlResult(_SELECT_SQL));
            _tempString +=  _SelectCount + "????" + _SELECT_SQL;
            if (_SelectCount == 0)
            {
                string _INSERST_SQL = @"insert into AnBiaoPingShen([PS_ID]
                           ,[PS_DanWei]
                           ,[PS_DanWeiDiZhi]
                           ,[PS_RiQiStart]
                           ,[PS_RiQiEnd]
                           ,[PS_Detail]
                           ,[PS_XiangMu]
                           ,[PS_RenWuShu]
                           ,[PS_DanWeiJianJie]
                           ,[PS_JieLun]
                           ,[PS_BuHege]
                           ,[PS_File]
						   ,[PS_Type]
                           ,[PS_DanWeiRenYuan]
                           ,[PS_DanWeiShengChan]
                           ,[PS_DanWeiJianChe]
                           ,[PS_RenYuan],[PS_AddTime]) values('" + PS_ID + "','" +
    PS_DanWei + "','" +
    PS_DanWeiDiZhi + "','" +
    PS_RiQiStart + "','" +
    PS_RiQiEnd + "','" +
    PS_Detail + "','" +
    PS_XiangMu+ "','" +
    PS_RenWuShu + "','" +
    PS_DanWeiJianJie + "','" +
    PS_JieLun + "','" +
    PS_BuHege + "','" +
    PS_File + "','" +
    PS_Type + "','" +
    PS_DanWeiRenYuan + "','" +
    PS_DanWeiShengChan + "','" +
    PS_DanWeiJianChe + "','" +
    PS_RenYuan + "','" +
    DateTime.Now.ToString("yyyyMMddHHmmss")  + "')";
                _tempString = _INSERST_SQL;
                int _InsertCount = Convert.ToInt16(Class1.ExecCommand(_INSERST_SQL));

                if (_InsertCount > 0)
                {
                    _tempString = "添加成功！";
                }
                else
                    _tempString = "添加失败！";

            }
            else {
                _tempString += _UPDATE_SQL + "????";
                string _tt = Class1.GetSqlResult(_UPDATE_SQL.ToString());
                _tempString = "修改成功！";

            }
        }
        return _tempString.ToString();


    }
    public static string urlconvertor(string imagesurl1)

    {

        string tmpRootDir = System.Web.HttpContext.Current.Server.MapPath(System.Web.HttpContext.Current.Request.ApplicationPath.ToString());//获取程序根目录
        tmpRootDir = tmpRootDir.Replace(@"/", @"\");
        string imagesurl2 = imagesurl1.Replace(tmpRootDir, ""); //转换成相对路径
        imagesurl2 = imagesurl2.Replace(@"\", @"/").Replace("d:/yj/kuangangs/","");
        string _tempUrl = "http://117.160.199.82:7777/" + imagesurl2;
        //imagesurl2 = imagesurl2.Replace(@"Aspx_Uc/", @"");
        return _tempUrl;
        // http://117.160.199.82/d:/yj/kuangangs/Temp/952864916c384f34ae0dc0cc19bb62a9.doc

    }
    //上传文件
    public string  upload_Files(  HttpContext context)
    {
        try
        {
            string returnString = "";
            string reqData = "";
            HttpFileCollection files = HttpContext.Current.Request.Files;
            string F_ID = HttpContext.Current.Request["filename"];
            string PS_ID = "";
            string fileFenlei = "";
            if(   !string.IsNullOrEmpty(HttpContext.Current.Request["PS_ID"]))
                PS_ID = HttpContext.Current.Request["PS_ID"];
            if(   !string.IsNullOrEmpty(HttpContext.Current.Request["fileFenlei"]))
                fileFenlei = HttpContext.Current.Request["fileFenlei"];
            HttpPostedFile file = null;
            List<string> fileUrl = new List<string>();
            if (files.Count != 0)
            {
                for (int t = 0; t < files.Count; t++)
                {
                    file = files[t];//这里只有一个文件 
                    if (string.IsNullOrEmpty(file.FileName) == false)
                    {
                        string mappath = HttpContext.Current.Server.MapPath("/AnBiao/" + PS_ID + "/" + fileFenlei+"/");
                        string filepath = mappath+ file.FileName.Replace(".doc",".docx");

                        if (Directory.Exists(mappath) == false)     /* 如果不存在就创建file文件夹 */
                        {
                            Directory.CreateDirectory(mappath);
                        }
                        if (File.Exists(filepath))
                        {
                            File.Delete(filepath);
                        }
                        file.SaveAs(filepath);
                        fileUrl.Add(urlconvertor(filepath));
                    }
                    else
                    {
                        returnString= "存储失败";
                    }

                }
            }
            else

                returnString= "无文件";
            if (fileUrl.Count > 0) {
                string res = string.Empty;
                fileUrl.ForEach(elment =>
                {
                    res += elment+",";
                });
                res = res.TrimEnd(',');
                string _tempSql = "update [AnBiaoPingShen] set " + fileFenlei + "='" + res + "'  where PS_ID ='" + PS_ID + "'";
                int _InsertCount = Convert.ToInt16(Class1.ExecCommand(_tempSql));
                returnString = res;

            }
            return returnString;
        }
        catch (Exception ex)
        {
            return  ex.Message.ToString() ;
        }

    }
    //上传文件
    public string  uploadImage(  HttpContext context)
    {
        try
        {
            string returnString = "";
            string reqData = "";
            HttpFileCollection files = HttpContext.Current.Request.Files;
            string F_ID = HttpContext.Current.Request["filename"];
            string PS_ID = "";
            string fileFenlei = "";
            if(   !string.IsNullOrEmpty(HttpContext.Current.Request["PS_ID"]))
                PS_ID = HttpContext.Current.Request["PS_ID"];
            if(   !string.IsNullOrEmpty(HttpContext.Current.Request["fileFenlei"]))
                fileFenlei = HttpContext.Current.Request["fileFenlei"];
            HttpPostedFile file = null;
            List<string> fileUrl = new List<string>();
            if (files.Count != 0)
            {
                for (int t = 0; t < files.Count; t++)
                {
                    file = files[t];//这里只有一个文件 
                    if (string.IsNullOrEmpty(file.FileName) == false)
                    {
                        string mappath = HttpContext.Current.Server.MapPath("/AnBiao/" + PS_ID + "/" + fileFenlei+"/");
                        string filetype = file.FileName.Substring(file.FileName.LastIndexOf('.'));
                        string filename=    Guid.NewGuid().ToString("N");
                        string filepath = mappath+  filename + filetype;

                        if (Directory.Exists(mappath) == false)     /* 如果不存在就创建file文件夹 */
                        {
                            Directory.CreateDirectory(mappath);
                        }
                        if (File.Exists(filepath))
                        {
                            File.Delete(filepath);
                        }
                        // 定义Task1
                        Task<string> task1 = Task.Run (() => { file.SaveAs(filepath); return filepath; });


                        // 定义Task2
                        Task<string> task2 = task1.ContinueWith((_Result) =>
                        {
                            // task2逻辑
                            string _filep =_Result.Result;
                            if (_filep.IndexOf("doc") != -1 && _filep.IndexOf("docx") == -1)
                            {
                                Document doc = new Document(_filep);  /* 建立Document物件 */
                                DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
                                string xuanzhong = char.ConvertFromUtf32(0x25A0);
                                string weixuanzhong = char.ConvertFromUtf32(0x25A1);
                                // move cursor to the desired position
                                builder.MoveTo(doc.LastSection.Body.LastParagraph);
                                // Insert HTML formatted content in Word document
                                builder.InsertHtml("");
                                System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1)); // 当地时区
                                long timeStamp = (long)(DateTime.Now - startTime).TotalSeconds; // 相差秒数
                                string outFile = saveFilePath + PS_ID + "\\" + fileFenlei + "\\" + filename + ".docx";
                                doc.Save(outFile);
                                _filep = outFile;
                            }
                            return _filep;
                        });

                        // 等待所有任务完成
                        Task.WhenAll(task1, task2);

                        // 获取返回值
                        string result1 = task1.Result;
                        string result2 = task2.Result;


                        fileUrl.Add(urlconvertor(filepath));
                        returnString = urlconvertor(result2);
                        //returnString = result2;
                    }
                    else
                    {
                        returnString= "存储失败";
                    }
                }
            }
            else
                returnString= "无文件";

            return  returnString.ToString() ;


        }
        catch (Exception ex)
        {
            return  ex.Message.ToString() ;
        }

    }


    #region
    ///<summary>
    ///读取文件夹中的全部文件并转成json格式 
    /// </summary>
    /// 

    public class FileInfo
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Dic { get; set; }
        public string Path { get; set; }
        public string ParentId { get; set; }
        public string Type { get; set; }
        public string Size { get; set; }
        public string Date { get; set; }

    }

    public string readFiles(HttpContext context)
    {
        string PS_ID = "";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{", "").Replace("}", "").Replace("\"", "");
        string[] jsonArray = json.Split(':');
        PS_ID = jsonArray.Length == 0 ? "" : jsonArray[0] == "" ? "23PJ3020" : jsonArray[1];
        if (PS_ID == "")
            return "PS_ID为空";

        List<object> objects = new List<object>();
        string filePath =  saveFilePath+PS_ID+"\\"; //  待压缩文件目录
        var tree = TraverseDirectory(filePath,0,PS_ID,0);
        _ID = 10000;
        var result = JsonConvert.SerializeObject(tree);


        return result.ToString();
    }
    public     static       int _ID = 10000;
/// <summary>
/// 列出文件夹下所有目录及文件，并返回json格式
/// </summary>
/// <param name="root"></param> 目录
/// <param name="_ps_ID"></param> 目录编号
/// <param name="PS_ID"></param> 任务编号
/// <param name="_parentID"></param> 父目录编号
/// <returns></returns>
    public static List<FileInfo> TraverseDirectory(string root,int _ps_ID,string PS_ID,int _parentID)
    {
        var files = new List<FileInfo>();
        var fileInfos = Directory.GetFiles(root);
            if(_ps_ID !=0)
        files.Add(  new FileInfo { ID=_ps_ID, Name = root.Replace(saveFilePath+PS_ID+"\\",""), Size =fileInfos.Length.ToString(), Date = Directory.GetCreationTime(root).ToString(), Type ="文件夹",
            Dic = (root).Replace(saveFilePath+PS_ID+"\\",""), ParentId =_parentID.ToString(), Path = "" }
        );
           
        var _fileInfos = Directory.GetFiles(root).Select(f => {
            bool isInRoot = String.Equals(Path.GetDirectoryName(f),root, StringComparison.OrdinalIgnoreCase);
            return new FileInfo {ID=_ID++, Name = Path.GetFileName(f).Replace(saveFilePath+PS_ID+"\\",""), Size = new System.IO.FileInfo(f).Length.ToString(), Date = new System.IO.FileInfo(f).CreationTime.ToString(), Type = new System.IO.FileInfo(f).Extension.ToString(),
                Dic = urlconvertor(Path.GetDirectoryName(f)), ParentId = _ps_ID.ToString(), Path = urlconvertor(f) };
        })
    .ToList();

        files.AddRange(_fileInfos);

        var subDirs = Directory.GetDirectories(root);
        for ( int t =0;t < subDirs.Length;t++)
        {
            files.AddRange(TraverseDirectory(subDirs[t],_ps_ID+1+t,PS_ID,_parentID));
        }

        return files;
    }
    #endregion
    #region
    ///<summary>
    ///生成zip文件并下载 
    /// </summary>
    public string downLoadZipFiles(HttpContext context)
    {
        string PS_ID ="";
        var stream = context.Request.InputStream;
        var _tempString = "";
        string json = new StreamReader(stream).ReadToEnd().Replace("{","").Replace("}","").Replace("\"","");
        string[] jsonArray = json.Split(':');
        PS_ID = jsonArray.Length == 0 ? "" :jsonArray[0]==""?"23PJ3020": jsonArray[1];
        if (PS_ID != "")
        {
            string[] FileProperties = new string[2];
            FileProperties[0] =saveFilePath+ PS_ID+".zip";//   压缩后的目标文件 
            FileProperties[1] = saveFilePath+PS_ID+"\\"; //  待压缩文件目录
            //ZipClass Zc = new ZipClass();
            //Zc.ZipFileMain(FileProperties);
            string rarurlPath = string.Empty;
            Boolean bo = false;
            //压缩文件

            System.Diagnostics.Process pro = new System.Diagnostics.Process();
            // pro.StartInfo.FileName = saveFilePath+@"\WinRAR\WinRAR.exe";//WinRAR所在路径
            pro.StartInfo.FileName = @"C:\Program Files\Bandizip\Bandizip.exe";
            //pro.StartInfo.Arguments = "a " + yasuoPathSave + " " + yasuoPath + " -r ";//dir是你的目录名
            pro.StartInfo.Arguments = string.Format("a {0} {1} -r",FileProperties[0],FileProperties[1]);
            pro.Start();
            TimeSpan times = pro.TotalProcessorTime;
            bo = pro.WaitForExit(6000);//设定一分钟
            if (!bo)
                pro.Kill();
            pro.Close();
            pro.Dispose();
            PS_ID = FileProperties[0];
            //rarurlPath = yasuoPathSave;
        }
        return urlconvertor( PS_ID);
    }
    #endregion

    /// <summary> 
    /// asp.net上传图片并生成缩略图 
    /// </summary> 
    /// <param name="upImage">HtmlInputFile控件</param> 
    /// <param name="sSavePath">保存的路径,些为相对服务器路径的下的文件夹</param> 
    /// <param name="sThumbExtension">缩略图的thumb</param> 
    /// <param name="intThumbWidth">生成缩略图的宽度</param> 
    /// <param name="intThumbHeight">生成缩略图的高度</param> 
    /// <returns>缩略图名称</returns> 
    public string uploadFiles(HttpContext context)
    {
        var stream = context.Request.InputStream;
        string json = new StreamReader(stream).ReadToEnd();
        return json;
    }
    public string show(HttpContext context)
    {
        string _tempText = "";
        if (!string.IsNullOrEmpty(context.Request.QueryString["ids"]))
            _tempText = context.Request.QueryString["ids"];
        return _tempText;
    }
    protected static string templetFilePath = ConfigurationSettings.AppSettings["TempletFilePath"];
    protected static string saveFilePath = ConfigurationSettings.AppSettings["SaveFilePathAnBiao"];
    public class _temp
    {
        public string ids {get;set; }
        public string PS_XiangMu {get;set; }
        public string PS_JieLunDetail {get;set; }
        public object postObj { get; set; }
    }
    public class _baogao
    {
        public string ids {get;set; }
        public string PS_XiangMu {get;set; }
    }
    public string pingshenBaogao(HttpContext context)
    {

        var stream = context.Request.InputStream;
        string tempFile = templetFilePath + "pingshenBaogao.docx";
        string json = new StreamReader(stream).ReadToEnd();
        _temp _temp_jo = JsonConvert.DeserializeObject<_temp>(json);//反序列化;
        string ids = _temp_jo.ids;//反序列化;
        string PS_XiangMu = _temp_jo.PS_XiangMu;


        //string zone = jo.xm2_1Panding.ToString()=="合格"?"":"";//输出 深圳
        Document doc = new Document(tempFile);  /* 建立Document物件 */
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        string xuanzhong = char.ConvertFromUtf32(0x25A0);
        string weixuanzhong = char.ConvertFromUtf32(0x25A1);
        // move cursor to the desired position
        builder.MoveTo(doc.LastSection.Body.LastParagraph);
        // Insert HTML formatted content in Word document
        builder.InsertHtml(PS_XiangMu);

        System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1)); // 当地时区
        long timeStamp = (long)(DateTime.Now - startTime).TotalSeconds; // 相差秒数
        string outFile = saveFilePath + timeStamp.ToString() + ".doc";
        doc.Save(outFile);
        return outFile;
    }
    public string docTodocx(HttpContext context)
    {

        var stream = context.Request.InputStream;
        string tempFile = templetFilePath + "anbiao_baogao.doc";

        Document doc = new Document(tempFile);  /* 建立Document物件 */
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        string xuanzhong = char.ConvertFromUtf32(0x25A0);
        string weixuanzhong = char.ConvertFromUtf32(0x25A1);
        // move cursor to the desired position
        builder.MoveTo(doc.LastSection.Body.LastParagraph);
        // Insert HTML formatted content in Word document
        builder.InsertHtml("asfddddddddddddddd");
        System.DateTime startTime = TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1)); // 当地时区
        long timeStamp = (long)(DateTime.Now - startTime).TotalSeconds; // 相差秒数
        string outFile = saveFilePath +@"23PJ3020\readDoc\"+ timeStamp.ToString() + ".docx";
        doc.Save(outFile);
        return outFile;
    }
    public string shengchengBaogao(HttpContext context)
    {

        var stream = context.Request.InputStream;
        string tempFile = templetFilePath + "anbiao_jilu.docx";
        string json = new StreamReader(stream).ReadToEnd();
        _temp _temp_jo = JsonConvert.DeserializeObject<_temp>(json);//反序列化;

        string ids =_temp_jo.ids;//反序列化;
        string PS_XiangMu = _temp_jo.PS_XiangMu;
        string PS_JieLunDetail = _temp_jo.PS_JieLunDetail;
        string _tempSring =_temp_jo.postObj.ToString();//反序列化;

        Student jo = JsonConvert.DeserializeObject<Student>(_tempSring);//反序列化;
        if (ids  != "") {
            string _tempSql = "update AnBiaoPingShen set PS_Detail ='" + _tempSring + "', PS_JieLunDetail ='" + PS_JieLunDetail + "',PS_XiangMu='"+PS_XiangMu+"' where PS_ID='" + ids + "'";
            Class1.ExecSql(_tempSql);
        }

        //string zone = jo.xm2_1Panding.ToString()=="合格"?"":"";//输出 深圳
        Document doc = new Document(tempFile);  /* 建立Document物件 */
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        string xuanzhong = char.ConvertFromUtf32(0x25A0);
        string weixuanzhong = char.ConvertFromUtf32(0x25A1);
        #region
        string[,] siblings=new string[0,0] ;
        if(jo!=null)
            siblings = new string[,] {
                         { "xm_BianHao", jo.xm_BianHao==null?"/":jo.xm_BianHao },
                         { "xm_ChangJia", jo.xm_ChangJia==null?"/":jo.xm_ChangJia },
                         { "xm_PingShenZhu", jo.xm_PingShenZhu==null?"/":jo.xm_PingShenZhu },
                         { "xm_StartTime", jo.xm_StartTime==null?"/":jo.xm_StartTime },
                         { "xm_EndTime", jo.xm_EndTime==null?"/":jo.xm_EndTime },

                        { "xm_2JieDai", jo.xm_2JieDai==null?"/":jo.xm_2JieDai },
                        { "xm_3JieDai", jo.xm_3JieDai==null?"/":jo.xm_3JieDai },
                        { "xm_4JieDai", jo.xm_4JieDai==null?"/":jo.xm_4JieDai },
                        { "xm_5JieDai", jo.xm_5JieDai==null?"/":jo.xm_5JieDai },
                        { "xm_6JieDai", jo.xm_6JieDai==null?"/":jo.xm_6JieDai },
                        { "xm_7JieDai", jo.xm_7JieDai==null?"/":jo.xm_7JieDai },
                        { "xm_8JieDai", jo.xm_8JieDai==null?"/":jo.xm_8JieDai },
                        { "xm_9JieDai", jo.xm_9JieDai==null?"/":jo.xm_9JieDai },
                        { "xm_10JieDai", jo.xm_10JieDai==null?"/":jo.xm_10JieDai },
                        { "xm_11JieDai", jo.xm_11JieDai==null?"/":jo.xm_11JieDai },
                        { "xm_12JieDai", jo.xm_12JieDai==null?"/":jo.xm_12JieDai },
                        { "xm_13JieDai", jo.xm_13JieDai==null?"/":jo.xm_13JieDai },


                        { "xm2_1Panding_1_1", jo.xm2_1Panding_1 ==null?weixuanzhong:jo.xm2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_1_2", jo.xm2_1Panding_1 ==null?weixuanzhong:jo.xm2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_2_1", jo.xm2_1Panding_2 ==null?weixuanzhong:jo.xm2_1Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_2_2", jo.xm2_1Panding_2 ==null?weixuanzhong:jo.xm2_1Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_3_1", jo.xm2_1Panding_3 ==null?weixuanzhong:jo.xm2_1Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_3_2", jo.xm2_1Panding_3 ==null?weixuanzhong:jo.xm2_1Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_3_3", jo.xm2_1Panding_3 ==null?weixuanzhong:jo.xm2_1Panding_3 == "不适用" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_4_0", jo.xm2_1Panding_4==null?"/":jo.xm2_1Panding_4 },

                        { "xm2_2Panding_1_1", jo.xm2_2Panding_1 ==null?weixuanzhong:jo.xm2_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_1_2", jo.xm2_2Panding_1 ==null?weixuanzhong:jo.xm2_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_2_1", jo.xm2_2Panding_2 ==null?weixuanzhong:jo.xm2_2Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_2_2", jo.xm2_2Panding_2 ==null?weixuanzhong:jo.xm2_2Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_3_0", jo.xm2_2Panding_3==null?"/":jo.xm2_2Panding_3 },
                        { "xm2_2Panding_4_0", jo.xm2_2Panding_4==null?"/":jo.xm2_2Panding_4 },
                        { "xm2_2Panding_5_1", jo.xm2_2Panding_5 ==null?weixuanzhong:jo.xm2_2Panding_5 == "01" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_5_2", jo.xm2_2Panding_5 ==null?weixuanzhong:jo.xm2_2Panding_5 == "02" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_5_3", jo.xm2_2Panding_5 ==null?weixuanzhong:jo.xm2_2Panding_5 == "03" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_5_4", jo.xm2_2Panding_5 ==null?weixuanzhong:jo.xm2_2Panding_5 == "04" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_6_0", jo.xm2_2Panding_6==null?"/":jo.xm2_2Panding_6 },


                        {"xm3_1_1Panding_1_1",jo.xm3_1_1Panding_1==null?weixuanzhong:jo.xm3_1_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_1_2",jo.xm3_1_1Panding_1==null?weixuanzhong:jo.xm3_1_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_1_3",jo.xm3_1_1Panding_1==null?weixuanzhong:jo.xm3_1_1Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_2_1",jo.xm3_1_1Panding_2==null?weixuanzhong:jo.xm3_1_1Panding_2=="是"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_2_2",jo.xm3_1_1Panding_2==null?weixuanzhong:jo.xm3_1_1Panding_2=="否"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_2_3",jo.xm3_1_1Panding_2==null?weixuanzhong:jo.xm3_1_1Panding_2=="欠"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_3_0",jo.xm3_1_1Panding_3==null?"/":jo.xm3_1_1Panding_3},


                        {"xm3_1_2Panding_1_1",jo.xm3_1_2Panding_1==null?weixuanzhong:jo.xm3_1_2Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_1_2",jo.xm3_1_2Panding_1==null?weixuanzhong:jo.xm3_1_2Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_1_3",jo.xm3_1_2Panding_1==null?weixuanzhong:jo.xm3_1_2Panding_1=="欠"?xuanzhong:weixuanzhong},

                        {"xm3_1_2Panding_2_1",jo.xm3_1_2Panding_2==null?weixuanzhong:jo.xm3_1_2Panding_2=="是"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_2_2",jo.xm3_1_2Panding_2==null?weixuanzhong:jo.xm3_1_2Panding_2=="否"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_2_3",jo.xm3_1_2Panding_2==null?weixuanzhong:jo.xm3_1_2Panding_2=="欠"?xuanzhong:weixuanzhong},

                        {"xm3_1_2Panding_3_1",jo.xm3_1_2Panding_3==null?weixuanzhong:jo.xm3_1_2Panding_3=="是"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_3_2",jo.xm3_1_2Panding_3==null?weixuanzhong:jo.xm3_1_2Panding_3=="否"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_3_3",jo.xm3_1_2Panding_3==null?weixuanzhong:jo.xm3_1_2Panding_3=="欠"?xuanzhong:weixuanzhong},


                        {"xm3_1_2Panding_4_0",jo.xm3_1_2Panding_4==null?"/":jo.xm3_1_2Panding_4},


                        {"xm3_2_1Panding_1_1",jo.xm3_2_1Panding_1==null?weixuanzhong:jo.xm3_2_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_1_2",jo.xm3_2_1Panding_1==null?weixuanzhong:jo.xm3_2_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_1_3",jo.xm3_2_1Panding_1==null?weixuanzhong:jo.xm3_2_1Panding_1=="欠"?xuanzhong:weixuanzhong},

                        {"xm3_2_1Panding_2_1",jo.xm3_2_1Panding_2==null?weixuanzhong:jo.xm3_2_1Panding_2=="是"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_2_2",jo.xm3_2_1Panding_2==null?weixuanzhong:jo.xm3_2_1Panding_2=="否"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_2_3",jo.xm3_2_1Panding_2==null?weixuanzhong:jo.xm3_2_1Panding_2=="欠"?xuanzhong:weixuanzhong},

                        {"xm3_2_1Panding_3_0",jo.xm3_2_1Panding_3==null?"/":jo.xm3_2_1Panding_3},
                        {"xm3_2_1Panding_4_0",jo.xm3_2_1Panding_4==null?"/":jo.xm3_2_1Panding_4},
                        {"xm3_2_1Panding_5_0",jo.xm3_2_1Panding_5==null?"/":jo.xm3_2_1Panding_5},
                        {"xm3_2_1Panding_6_0",jo.xm3_2_1Panding_6==null?"/":jo.xm3_2_1Panding_6},

                        {"xm3_2_1Panding_7_1",jo.xm3_2_1Panding_7==null?weixuanzhong:jo.xm3_2_1Panding_7=="是"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_7_2",jo.xm3_2_1Panding_7==null?weixuanzhong:jo.xm3_2_1Panding_7=="否"?xuanzhong:weixuanzhong},

                        {"xm3_2_1Panding_8_1",jo.xm3_2_1Panding_8==null?weixuanzhong:jo.xm3_2_1Panding_8=="是"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_8_2",jo.xm3_2_1Panding_8==null?weixuanzhong:jo.xm3_2_1Panding_8=="否"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_9_0",jo.xm3_2_1Panding_9==null?"/":jo.xm3_2_1Panding_9},

                        {"xm3_2_2Panding_1_1",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("01")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_1_2",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("02")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_1_3",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("03")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_1_4",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("04")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_1_5",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("05")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_1_6",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("06")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_1_7",jo.xm3_2_2Panding_1==null?weixuanzhong:jo.xm3_2_2Panding_1.IndexOf("07")!=-1?xuanzhong:weixuanzhong},

                        {"xm3_2_2Panding_2_0",jo.xm3_2_2Panding_2==null?"/":dateFormat(jo.xm3_2_2Panding_2)},
                        {"xm3_2_2Panding_3_0",jo.xm3_2_2Panding_3==null?"/":jo.xm3_2_2Panding_3},
                        {"xm3_2_2Panding_4_0",jo.xm3_2_2Panding_4==null?"/":jo.xm3_2_2Panding_4},
                        {"xm3_2_2Panding_5_0",jo.xm3_2_2Panding_5==null?"/":jo.xm3_2_2Panding_5},
                        {"xm3_2_2Panding_6_0",jo.xm3_2_2Panding_6==null?"/":jo.xm3_2_2Panding_6},


                        {"xm3_2_3Panding_1_1",jo.xm3_2_3Panding_1==null?weixuanzhong:jo.xm3_2_3Panding_1.IndexOf("01")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_3Panding_1_2",jo.xm3_2_3Panding_1==null?weixuanzhong:jo.xm3_2_3Panding_1.IndexOf("02")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_3Panding_1_3",jo.xm3_2_3Panding_1==null?weixuanzhong:jo.xm3_2_3Panding_1.IndexOf("03")!=-1?xuanzhong:weixuanzhong},
                        {"xm3_2_3Panding_1_4",jo.xm3_2_3Panding_1==null?weixuanzhong:jo.xm3_2_3Panding_1.IndexOf("04")!=-1?xuanzhong:weixuanzhong},


                        {"xm3_2_3Panding_2_0",jo.xm3_2_3Panding_2==null?"/":dateFormat(jo.xm3_2_3Panding_2)},
                        {"xm3_2_3Panding_3_0",jo.xm3_2_3Panding_3==null?"/":jo.xm3_2_3Panding_3},


                        {"xm3_2_4Panding_1_1",jo.xm3_2_4Panding_1==null?weixuanzhong:jo.xm3_2_4Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm3_2_4Panding_1_2",jo.xm3_2_4Panding_1==null?weixuanzhong:jo.xm3_2_4Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm3_2_4Panding_1_3",jo.xm3_2_4Panding_1==null?weixuanzhong:jo.xm3_2_4Panding_1=="欠"?xuanzhong:weixuanzhong},

                        {"xm3_2_4Panding_2_0",jo.xm3_2_4Panding_2==null?"/":jo.xm3_2_4Panding_2},

                        { "xm4_1_1Panding_1_1", jo.xm4_1_1Panding_1 ==null?weixuanzhong:jo.xm4_1_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_1_2", jo.xm4_1_1Panding_1 ==null?weixuanzhong:jo.xm4_1_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_2_0", jo.xm4_1_1Panding_2==null?"/":jo.xm4_1_1Panding_2 },
                        { "xm4_1_1Panding_3_0", jo.xm4_1_1Panding_3==null?"/":jo.xm4_1_1Panding_3 },
                        { "xm4_1_1Panding_4_1", jo.xm4_1_1Panding_4 ==null?weixuanzhong:jo.xm4_1_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_4_2", jo.xm4_1_1Panding_4 ==null?weixuanzhong:jo.xm4_1_1Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_4_3", jo.xm4_1_1Panding_4 ==null?weixuanzhong:jo.xm4_1_1Panding_4 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_5_0", jo.xm4_1_1Panding_5==null?"/":jo.xm4_1_1Panding_5 },
                        { "xm4_1_1Panding_6_0", jo.xm4_1_1Panding_6==null?"/":jo.xm4_1_1Panding_6 },
                        { "xm4_1_1Panding_7_1", jo.xm4_1_1Panding_7==null?weixuanzhong:jo.xm4_1_1Panding_7.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_7_2", jo.xm4_1_1Panding_7==null?weixuanzhong:jo.xm4_1_1Panding_7.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_7_3", jo.xm4_1_1Panding_7==null?weixuanzhong:jo.xm4_1_1Panding_7.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_7_4", jo.xm4_1_1Panding_7==null?weixuanzhong:jo.xm4_1_1Panding_7.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_7_5", jo.xm4_1_1Panding_7==null?weixuanzhong:jo.xm4_1_1Panding_7.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_1_1Panding_8_0", jo.xm4_1_1Panding_8==null?"/":jo.xm4_1_1Panding_8 },

                        { "xm4_1_2Panding_1_1", jo.xm4_1_2Panding_1 ==null?weixuanzhong:jo.xm4_1_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_1_2Panding_1_2", jo.xm4_1_2Panding_1 ==null?weixuanzhong:jo.xm4_1_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_1_2Panding_1_3", jo.xm4_1_2Panding_1 ==null?weixuanzhong:jo.xm4_1_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm4_1_2Panding_2_0", jo.xm4_1_2Panding_2==null?"/":jo.xm4_1_2Panding_2 },

                        { "xm4_2_1Panding_1_1", jo.xm4_2_1Panding_1 ==null?weixuanzhong:jo.xm4_2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_1_2", jo.xm4_2_1Panding_1 ==null?weixuanzhong:jo.xm4_2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_2_0", jo.xm4_2_1Panding_2==null?"/":jo.xm4_2_1Panding_2 },
                        { "xm4_2_1Panding_3_0", jo.xm4_2_1Panding_3==null?"/":jo.xm4_2_1Panding_3 },
                        { "xm4_2_1Panding_4_1", jo.xm4_2_1Panding_4 ==null?weixuanzhong:jo.xm4_2_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_4_2", jo.xm4_2_1Panding_4 ==null?weixuanzhong:jo.xm4_2_1Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_4_3", jo.xm4_2_1Panding_4 ==null?weixuanzhong:jo.xm4_2_1Panding_4 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_5_0", jo.xm4_2_1Panding_5==null?"/":jo.xm4_2_1Panding_5 },
                        { "xm4_2_1Panding_6_0", jo.xm4_2_1Panding_6==null?"/":jo.xm4_2_1Panding_6 },
                        { "xm4_2_1Panding_7_1", jo.xm4_2_1Panding_7==null?weixuanzhong:jo.xm4_2_1Panding_7.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_7_2", jo.xm4_2_1Panding_7==null?weixuanzhong:jo.xm4_2_1Panding_7.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_7_3", jo.xm4_2_1Panding_7==null?weixuanzhong:jo.xm4_2_1Panding_7.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_7_4", jo.xm4_2_1Panding_7==null?weixuanzhong:jo.xm4_2_1Panding_7.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm4_2_1Panding_8_0", jo.xm4_2_1Panding_8==null?"/":jo.xm4_2_1Panding_8 },

                        { "xm4_2_2Panding_1_1", jo.xm4_2_2Panding_1 ==null?weixuanzhong:jo.xm4_2_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_2_2Panding_1_2", jo.xm4_2_2Panding_1 ==null?weixuanzhong:jo.xm4_2_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_2_2Panding_1_3", jo.xm4_2_2Panding_1 ==null?weixuanzhong:jo.xm4_2_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm4_2_2Panding_2_0", jo.xm4_2_2Panding_2==null?"/":jo.xm4_2_2Panding_2 },

                        { "xm4_3Panding_1_1", jo.xm4_3Panding_1==null?"/":jo.xm4_3Panding_1 },
                        { "xm4_3Panding_1_2", jo.xm4_3Panding_1==null?"/":jo.xm4_3Panding_1 },
                        { "xm4_3Panding_1_3", jo.xm4_3Panding_1==null?"/":jo.xm4_3Panding_1 },
                        { "xm4_3Panding_2_0", jo.xm4_3Panding_2==null?"/":jo.xm4_3Panding_2 },
                        { "xm4_3Panding_3_0", jo.xm4_3Panding_3==null?"/":jo.xm4_3Panding_3 },
                        { "xm4_3Panding_4_0", jo.xm4_3Panding_4==null?"/":jo.xm4_3Panding_4 },
                        { "xm4_3Panding_5_0", jo.xm4_3Panding_5==null?"/":jo.xm4_3Panding_5 },
                        { "xm4_3Panding_6_0", jo.xm4_3Panding_6==null?"/":jo.xm4_3Panding_6 },
                        { "xm4_3Panding_7_0", jo.xm4_3Panding_7==null?"/":jo.xm4_3Panding_7 },
                        { "xm4_3Panding_8_0", jo.xm4_3Panding_8==null?"/":jo.xm4_3Panding_8 },
                        { "xm4_3Panding_9_0", jo.xm4_3Panding_9==null?"/":jo.xm4_3Panding_9 },
                        { "xm4_3Panding_10_0", jo.xm4_3Panding_10==null?"/":jo.xm4_3Panding_10 },
                        { "xm4_3Panding_11_1", jo.xm4_3Panding_11 ==null?weixuanzhong:jo.xm4_3Panding_11 == "是" ? xuanzhong : weixuanzhong },
                        { "xm4_3Panding_11_2", jo.xm4_3Panding_11 ==null?weixuanzhong:jo.xm4_3Panding_11 == "否" ? xuanzhong : weixuanzhong },
                        { "xm4_3Panding_11_3", jo.xm4_3Panding_11 ==null?weixuanzhong:jo.xm4_3Panding_11 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm4_3Panding_12_0", jo.xm4_3Panding_12==null?"/":jo.xm4_3Panding_12 },

                        { "xm4_2_2Panding_2_0", jo.xm4_3Panding_12==null?"/":jo.xm4_3Panding_12 },

                        { "xm5_1_1Panding_1_1", jo.xm5_1_1Panding_1 ==null?weixuanzhong:jo.xm5_1_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_1_1Panding_1_2", jo.xm5_1_1Panding_1 ==null?weixuanzhong:jo.xm5_1_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_1_1Panding_1_3", jo.xm5_1_1Panding_1 ==null?weixuanzhong:jo.xm5_1_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_1_1Panding_2_0", jo.xm5_1_1Panding_2==null?"/":jo.xm5_1_1Panding_2 },
                        { "xm5_1_1Panding_3_0", jo.xm5_1_1Panding_3==null?"/":jo.xm5_1_1Panding_3 },
                        { "xm5_1_1Panding_4_0", jo.xm5_1_1Panding_4==null?"/":jo.xm5_1_1Panding_4 },

                        { "xm5_1_2Panding_1_1", jo.xm5_1_2Panding_1 ==null?weixuanzhong:jo.xm5_1_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_1_2Panding_1_2", jo.xm5_1_2Panding_1 ==null?weixuanzhong:jo.xm5_1_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_1_2Panding_1_3", jo.xm5_1_2Panding_1 ==null?weixuanzhong:jo.xm5_1_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_1_2Panding_2_0", jo.xm5_1_2Panding_2==null?"/":jo.xm5_1_2Panding_2 },
                        { "xm5_1_2Panding_3_0", jo.xm5_1_2Panding_3==null?"/":jo.xm5_1_2Panding_3 },
                        { "xm5_1_2Panding_4_0", jo.xm5_1_2Panding_4==null?"/":jo.xm5_1_2Panding_4 },
                        { "xm5_1_2Panding_5_0", jo.xm5_1_2Panding_5==null?"/":jo.xm5_1_2Panding_5 },
                        { "xm5_1_2Panding_6_0", jo.xm5_1_2Panding_6==null?"/":jo.xm5_1_2Panding_6 },
                        { "xm5_1_2Panding_7_0", jo.xm5_1_2Panding_7==null?"/":jo.xm5_1_2Panding_7 },
                        { "xm5_1_2Panding_8_0", jo.xm5_1_2Panding_8==null?"/":jo.xm5_1_2Panding_8 },

                        { "xm5_2_1Panding_1_1", jo.xm5_2_1Panding_1 ==null?weixuanzhong:jo.xm5_2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_1_2", jo.xm5_2_1Panding_1 ==null?weixuanzhong:jo.xm5_2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_1_3", jo.xm5_2_1Panding_1 ==null?weixuanzhong:jo.xm5_2_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_2_0", jo.xm5_2_1Panding_2==null?"/":jo.xm5_2_1Panding_2 },
                        { "xm5_2_1Panding_3_0", jo.xm5_2_1Panding_3==null?"/":jo.xm5_2_1Panding_3 },
                        { "xm5_2_1Panding_4_1", jo.xm5_2_1Panding_4 ==null?weixuanzhong:jo.xm5_2_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_4_2", jo.xm5_2_1Panding_4 ==null?weixuanzhong:jo.xm5_2_1Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_5_0", jo.xm5_2_1Panding_5==null?"/":jo.xm5_2_1Panding_5 },
                        { "xm5_2_1Panding_6_0", jo.xm5_2_1Panding_6==null?"/":jo.xm5_2_1Panding_6 },
                        { "xm5_2_1Panding_7_0", jo.xm5_2_1Panding_7==null?"/":jo.xm5_2_1Panding_7 },
                        { "xm5_2_1Panding_8_0", jo.xm5_2_1Panding_8==null?"/":jo.xm5_2_1Panding_8 },
                        { "xm5_2_1Panding_9_0", jo.xm5_2_1Panding_9==null?"/":jo.xm5_2_1Panding_9 },
                        { "xm5_2_1Panding_10_0", jo.xm5_2_1Panding_10==null?"/":jo.xm5_2_1Panding_10 },
                        { "xm5_2_1Panding_11_0", jo.xm5_2_1Panding_11==null?"/":jo.xm5_2_1Panding_11 },
                        { "xm5_2_1Panding_12_0", jo.xm5_2_1Panding_12==null?"/":jo.xm5_2_1Panding_12 },
                        { "xm5_2_1Panding_13_1", jo.xm5_2_1Panding_13 ==null?weixuanzhong:jo.xm5_2_1Panding_13 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_13_2", jo.xm5_2_1Panding_13 ==null?weixuanzhong:jo.xm5_2_1Panding_13 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_2_1Panding_14_0", jo.xm5_2_1Panding_14==null?"/":jo.xm5_2_1Panding_14 },
                        { "xm5_2_1Panding_15_0", jo.xm5_2_1Panding_15==null?"/":jo.xm5_2_1Panding_15 },
                        { "xm5_2_1Panding_16_0", jo.xm5_2_1Panding_16==null?"/":jo.xm5_2_1Panding_16 },
                        { "xm5_2_1Panding_17_0", jo.xm5_2_1Panding_17==null?"/":jo.xm5_2_1Panding_17 },
                        { "xm5_2_1Panding_18_0", jo.xm5_2_1Panding_18==null?"/":jo.xm5_2_1Panding_18 },
                        { "xm5_2_1Panding_19_0", jo.xm5_2_1Panding_19==null?"/":jo.xm5_2_1Panding_19 },
                        { "xm5_2_1Panding_20_0", jo.xm5_2_1Panding_20==null?"/":jo.xm5_2_1Panding_20 },

                        { "xm5_2_2Panding_1_1", jo.xm5_2_2Panding_1 ==null?weixuanzhong:jo.xm5_2_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_2_2Panding_1_2", jo.xm5_2_2Panding_1 ==null?weixuanzhong:jo.xm5_2_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_2_2Panding_2_1", jo.xm5_2_2Panding_2 ==null?weixuanzhong:jo.xm5_2_2Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_2_2Panding_2_2", jo.xm5_2_2Panding_2 ==null?weixuanzhong:jo.xm5_2_2Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_2_2Panding_2_3", jo.xm5_2_2Panding_2 ==null?weixuanzhong:jo.xm5_2_2Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_2_2Panding_3_0", jo.xm5_2_2Panding_3==null?"/":jo.xm5_2_2Panding_3 },

                        { "xm5_3_1Panding_1_1", jo.xm5_3_1Panding_1 ==null?weixuanzhong:jo.xm5_3_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_3_1Panding_1_2", jo.xm5_3_1Panding_1 ==null?weixuanzhong:jo.xm5_3_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_3_1Panding_1_3", jo.xm5_3_1Panding_1 ==null?weixuanzhong:jo.xm5_3_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_3_1Panding_2_0", jo.xm5_3_1Panding_2==null?"/":jo.xm5_3_1Panding_2 },
                        { "xm5_3_1Panding_3_0", jo.xm5_3_1Panding_3==null?"/":jo.xm5_3_1Panding_3 },
                        { "xm5_3_1Panding_4_0", jo.xm5_3_1Panding_4 ==null?weixuanzhong:jo.xm5_3_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_3_1Panding_5_0", jo.xm5_3_1Panding_5==null?"/":jo.xm5_3_1Panding_5 },
                        { "xm5_3_1Panding_6_0", jo.xm5_3_1Panding_6==null?"/":jo.xm5_3_1Panding_6 },
                        { "xm5_3_1Panding_7_0", jo.xm5_3_1Panding_7==null?"/":jo.xm5_3_1Panding_7 },

                        { "xm5_3_2Panding_1_1", jo.xm5_3_2Panding_1 ==null?weixuanzhong:jo.xm5_3_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_3_2Panding_1_2", jo.xm5_3_2Panding_1 ==null?weixuanzhong:jo.xm5_3_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_3_2Panding_1_3", jo.xm5_3_2Panding_1 ==null?weixuanzhong:jo.xm5_3_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_3_2Panding_2_0", jo.xm5_3_2Panding_2==null?"/":jo.xm5_3_2Panding_2 },
                        { "xm5_3_2Panding_3_0", jo.xm5_3_2Panding_3==null?"/":jo.xm5_3_2Panding_3 },
                        { "xm5_3_2Panding_4_1", jo.xm5_3_2Panding_4==null?weixuanzhong:jo.xm5_3_2Panding_4.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm5_3_2Panding_4_2", jo.xm5_3_2Panding_4==null?weixuanzhong:jo.xm5_3_2Panding_4.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm5_3_2Panding_4_3", jo.xm5_3_2Panding_4==null?weixuanzhong:jo.xm5_3_2Panding_4.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm5_3_2Panding_5_0", jo.xm5_3_2Panding_5==null?"/":jo.xm5_3_2Panding_5 },
                        { "xm5_3_2Panding_6_0", jo.xm5_3_2Panding_6==null?"/":jo.xm5_3_2Panding_6 },
                        { "xm5_3_2Panding_7_0", jo.xm5_3_2Panding_7==null?"/":jo.xm5_3_2Panding_7 },

                        { "xm5_4_1Panding_1_1", jo.xm5_4_1Panding_1 ==null?weixuanzhong:jo.xm5_4_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_1Panding_1_2", jo.xm5_4_1Panding_1 ==null?weixuanzhong:jo.xm5_4_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_4_1Panding_1_3", jo.xm5_4_1Panding_1 ==null?weixuanzhong:jo.xm5_4_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_4_1Panding_2_0", jo.xm5_4_1Panding_2==null?"/":jo.xm5_4_1Panding_2 },
                        { "xm5_4_1Panding_3_0", jo.xm5_4_1Panding_3==null?"/":jo.xm5_4_1Panding_3 },
                        { "xm5_4_1Panding_4_0", jo.xm5_4_1Panding_4 ==null?weixuanzhong:jo.xm5_4_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_1Panding_5_0", jo.xm5_4_1Panding_5==null?"/":jo.xm5_4_1Panding_5 },
                        { "xm5_4_1Panding_6_0", jo.xm5_4_1Panding_6==null?"/":jo.xm5_4_1Panding_6 },
                        { "xm5_4_1Panding_7_0", jo.xm5_4_1Panding_7 ==null?weixuanzhong:jo.xm5_4_1Panding_7 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_1Panding_8_0", jo.xm5_4_1Panding_8==null?"/":jo.xm5_4_1Panding_8 },
                        { "xm5_4_1Panding_9_0", jo.xm5_4_1Panding_9==null?"/":jo.xm5_4_1Panding_9 },
                        { "xm5_4_1Panding_10_0", jo.xm5_4_1Panding_10==null?"/":jo.xm5_4_1Panding_10 },
                        { "xm5_4_1Panding_11_0", jo.xm5_4_1Panding_11 ==null?weixuanzhong:jo.xm5_4_1Panding_11 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_1Panding_12_0", jo.xm5_4_1Panding_12==null?"/":jo.xm5_4_1Panding_12 },
                        { "xm5_4_1Panding_13_0", jo.xm5_4_1Panding_13==null?"/":jo.xm5_4_1Panding_13 },
                        { "xm5_4_1Panding_14_0", jo.xm5_4_1Panding_14==null?"/":jo.xm5_4_1Panding_14 },

                        { "xm5_4_2Panding_1_1", jo.xm5_4_2Panding_1 ==null?weixuanzhong:jo.xm5_4_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_1_2", jo.xm5_4_2Panding_1 ==null?weixuanzhong:jo.xm5_4_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_1_3", jo.xm5_4_2Panding_1 ==null?weixuanzhong:jo.xm5_4_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_2_0", jo.xm5_4_2Panding_2==null?"/":jo.xm5_4_2Panding_2 },
                        { "xm5_4_2Panding_3_1", jo.xm5_4_2Panding_3 ==null?weixuanzhong:jo.xm5_4_2Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_3_2", jo.xm5_4_2Panding_3 ==null?weixuanzhong:jo.xm5_4_2Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_3_3", jo.xm5_4_2Panding_3 ==null?weixuanzhong:jo.xm5_4_2Panding_3 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_4_0", jo.xm5_4_2Panding_4==null?"/":jo.xm5_4_2Panding_4 },
                        { "xm5_4_2Panding_5_0", jo.xm5_4_2Panding_5==null?"/":jo.xm5_4_2Panding_5 },
                        { "xm5_4_2Panding_6_1", jo.xm5_4_2Panding_6 ==null?weixuanzhong:jo.xm5_4_2Panding_6 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_6_2", jo.xm5_4_2Panding_6 ==null?weixuanzhong:jo.xm5_4_2Panding_6 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_6_3", jo.xm5_4_2Panding_6 ==null?weixuanzhong:jo.xm5_4_2Panding_6 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_7_0", jo.xm5_4_2Panding_7==null?"/":jo.xm5_4_2Panding_7 },
                        { "xm5_4_2Panding_8_0", jo.xm5_4_2Panding_8==null?"/":jo.xm5_4_2Panding_8 },
                        { "xm5_4_2Panding_9_1", jo.xm5_4_2Panding_9 ==null?weixuanzhong:jo.xm5_4_2Panding_9 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_9_2", jo.xm5_4_2Panding_9 ==null?weixuanzhong:jo.xm5_4_2Panding_9 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_9_3", jo.xm5_4_2Panding_9 ==null?weixuanzhong:jo.xm5_4_2Panding_9 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_4_2Panding_10_0", jo.xm5_4_2Panding_10==null?"/":jo.xm5_4_2Panding_10 },
                        { "xm5_4_2Panding_11_0", jo.xm5_4_2Panding_11==null?"/":jo.xm5_4_2Panding_11 },

                        { "xm5_5Panding_1_1", jo.xm5_5Panding_1 ==null?weixuanzhong:jo.xm5_5Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_5Panding_1_2", jo.xm5_5Panding_1 ==null?weixuanzhong:jo.xm5_5Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_5Panding_1_3", jo.xm5_5Panding_1 ==null?weixuanzhong:jo.xm5_5Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_5Panding_2_1", jo.xm5_5Panding_2 ==null?weixuanzhong:jo.xm5_5Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm5_5Panding_2_2", jo.xm5_5Panding_2 ==null?weixuanzhong:jo.xm5_5Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm5_5Panding_2_3", jo.xm5_5Panding_2 ==null?weixuanzhong:jo.xm5_5Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm5_5Panding_3_0", jo.xm5_5Panding_3==null?"/":jo.xm5_5Panding_3 },

                        { "xm6_1_1Panding_1_1", jo.xm6_1_1Panding_1 ==null?weixuanzhong:jo.xm6_1_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_1_1Panding_1_2", jo.xm6_1_1Panding_1 ==null?weixuanzhong:jo.xm6_1_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_1_1Panding_1_3", jo.xm6_1_1Panding_1 ==null?weixuanzhong:jo.xm6_1_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm6_1_1Panding_2_0", jo.xm6_1_1Panding_2==null?"/":jo.xm6_1_1Panding_2 },
                        { "xm6_1_1Panding_3_0", jo.xm6_1_1Panding_3==null?"/":jo.xm6_1_1Panding_3 },
                        { "xm6_1_1Panding_4_1", jo.xm6_1_1Panding_4 ==null?weixuanzhong:jo.xm6_1_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_1_1Panding_4_2", jo.xm6_1_1Panding_4 ==null?weixuanzhong:jo.xm6_1_1Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_1_1Panding_5_0", jo.xm6_1_1Panding_5==null?"/":jo.xm6_1_1Panding_5 },
                        { "xm6_1_2Panding_1_1", jo.xm6_1_2Panding_1 ==null?weixuanzhong:jo.xm6_1_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_1_2Panding_1_2", jo.xm6_1_2Panding_1 ==null?weixuanzhong:jo.xm6_1_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_1_2Panding_1_3", jo.xm6_1_2Panding_1 ==null?weixuanzhong:jo.xm6_1_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm6_1_2Panding_2_0", jo.xm6_1_2Panding_2==null?"/":jo.xm6_1_2Panding_2 },
                        { "xm6_1_2Panding_3_0", jo.xm6_1_2Panding_3==null?"/":jo.xm6_1_2Panding_3 },
                        { "xm6_1_2Panding_4_0", jo.xm6_1_2Panding_4==null?"/":jo.xm6_1_2Panding_4 },
                        { "xm6_1_2Panding_5_0", jo.xm6_1_2Panding_5==null?"/":jo.xm6_1_2Panding_5 },
                        { "xm6_1_2Panding_6_0", jo.xm6_1_2Panding_6==null?"/":jo.xm6_1_2Panding_6 },
                        { "xm6_1_2Panding_7_0", jo.xm6_1_2Panding_7==null?"/":jo.xm6_1_2Panding_7 },
                        { "xm6_1_2Panding_8_0", jo.xm6_1_2Panding_8==null?"/":jo.xm6_1_2Panding_8 },
                        { "xm6_1_2Panding_9_0", jo.xm6_1_2Panding_9==null?"/":jo.xm6_1_2Panding_9 },
                        { "xm6_1_2Panding_10_0", jo.xm6_1_2Panding_10==null?"/":jo.xm6_1_2Panding_10 },
                        { "xm6_1_3Panding_1_1", jo.xm6_1_3Panding_1 ==null?weixuanzhong:jo.xm6_1_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_1_3Panding_1_2", jo.xm6_1_3Panding_1 ==null?weixuanzhong:jo.xm6_1_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_1_3Panding_1_3", jo.xm6_1_3Panding_1 ==null?weixuanzhong:jo.xm6_1_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm6_1_3Panding_2_0", jo.xm6_1_3Panding_2==null?"/":jo.xm6_1_3Panding_2 },
                        { "xm6_1_3Panding_3_0", jo.xm6_1_3Panding_3==null?"/":jo.xm6_1_3Panding_3 },
                        { "xm6_1_3Panding_4_0", jo.xm6_1_3Panding_4==null?"/":jo.xm6_1_3Panding_4 },
                        { "xm6_1_3Panding_5_0", jo.xm6_1_3Panding_5==null?"/":jo.xm6_1_3Panding_5 },
                        { "xm6_1_3Panding_6_0", jo.xm6_1_3Panding_6==null?"/":jo.xm6_1_3Panding_6 },
                        { "xm6_1_4Panding_1_1", jo.xm6_1_4Panding_1==null?weixuanzhong:jo.xm6_1_4Panding_1.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_1_4Panding_1_2", jo.xm6_1_4Panding_1==null?weixuanzhong:jo.xm6_1_4Panding_1.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_1_4Panding_1_3", jo.xm6_1_4Panding_1==null?weixuanzhong:jo.xm6_1_4Panding_1.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_1_4Panding_1_4", jo.xm6_1_4Panding_1==null?weixuanzhong:jo.xm6_1_4Panding_1.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_1_4Panding_1_5", jo.xm6_1_4Panding_1==null?weixuanzhong:jo.xm6_1_4Panding_1.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_1_4Panding_1_6", jo.xm6_1_4Panding_1==null?weixuanzhong:jo.xm6_1_4Panding_1.IndexOf("06") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_1_4Panding_2_0", jo.xm6_1_4Panding_2==null?"/":jo.xm6_1_4Panding_2 },
                        { "xm6_2_1Panding_1_1", jo.xm6_2_1Panding_1 ==null?weixuanzhong:jo.xm6_2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_1_2", jo.xm6_2_1Panding_1 ==null?weixuanzhong:jo.xm6_2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_1_3", jo.xm6_2_1Panding_1 ==null?weixuanzhong:jo.xm6_2_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_2_0", jo.xm6_2_1Panding_2==null?"/":jo.xm6_2_1Panding_2 },
                        { "xm6_2_1Panding_3_0", jo.xm6_2_1Panding_3==null?"/":jo.xm6_2_1Panding_3 },
                        { "xm6_2_1Panding_4_1", jo.xm6_2_1Panding_4 ==null?weixuanzhong:jo.xm6_2_1Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_4_2", jo.xm6_2_1Panding_4 ==null?weixuanzhong:jo.xm6_2_1Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_5_1", jo.xm6_2_1Panding_5 ==null?weixuanzhong:jo.xm6_2_1Panding_5 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_5_2", jo.xm6_2_1Panding_5 ==null?weixuanzhong:jo.xm6_2_1Panding_5 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_6_1", jo.xm6_2_1Panding_6 ==null?weixuanzhong:jo.xm6_2_1Panding_6 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_6_2", jo.xm6_2_1Panding_6 ==null?weixuanzhong:jo.xm6_2_1Panding_6 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_7_1", jo.xm6_2_1Panding_7 ==null?weixuanzhong:jo.xm6_2_1Panding_7 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_7_2", jo.xm6_2_1Panding_7 ==null?weixuanzhong:jo.xm6_2_1Panding_7 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_1Panding_8_0", jo.xm6_2_1Panding_8==null?"/":jo.xm6_2_1Panding_8 },
                        { "xm6_2_2Panding_1_1", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_2", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_3", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_4", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_5", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_6", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("06") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_7", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("07") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_8", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("08") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_9", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("09") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_10", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("10") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_11", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("11") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_12", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("12") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_13", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("13") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_1_14", jo.xm6_2_2Panding_1==null?weixuanzhong:jo.xm6_2_2Panding_1.IndexOf("14") != -1 ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_2_1", jo.xm6_2_2Panding_2 ==null?weixuanzhong:jo.xm6_2_2Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_2_2", jo.xm6_2_2Panding_2 ==null?weixuanzhong:jo.xm6_2_2Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_3_1", jo.xm6_2_2Panding_3 ==null?weixuanzhong:jo.xm6_2_2Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_3_2", jo.xm6_2_2Panding_3 ==null?weixuanzhong:jo.xm6_2_2Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_4_1", jo.xm6_2_2Panding_4 ==null?weixuanzhong:jo.xm6_2_2Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_4_2", jo.xm6_2_2Panding_4 ==null?weixuanzhong:jo.xm6_2_2Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm6_2_2Panding_5_0", jo.xm6_2_2Panding_5==null?"/":jo.xm6_2_2Panding_5 },

                        { "xm7_1_1Panding_1_1", jo.xm7_1_1Panding_1 ==null?weixuanzhong:jo.xm7_1_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_1_2", jo.xm7_1_1Panding_1 ==null?weixuanzhong:jo.xm7_1_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_1_3", jo.xm7_1_1Panding_1 ==null?weixuanzhong:jo.xm7_1_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_2_0", jo.xm7_1_1Panding_2==null?"/":jo.xm7_1_1Panding_2 },
                        { "xm7_1_1Panding_3_0", jo.xm7_1_1Panding_3==null?"/":jo.xm7_1_1Panding_3 },
                        { "xm7_1_1Panding_4_1", jo.xm7_1_1Panding_4==null?weixuanzhong:jo.xm7_1_1Panding_4.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_4_2", jo.xm7_1_1Panding_4==null?weixuanzhong:jo.xm7_1_1Panding_4.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_4_3", jo.xm7_1_1Panding_4==null?weixuanzhong:jo.xm7_1_1Panding_4.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_4_4", jo.xm7_1_1Panding_4==null?weixuanzhong:jo.xm7_1_1Panding_4.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_4_5", jo.xm7_1_1Panding_4==null?weixuanzhong:jo.xm7_1_1Panding_4.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_1_1Panding_5_0", jo.xm7_1_1Panding_5==null?"/":jo.xm7_1_1Panding_5 },
                        { "xm7_1_2Panding_1_1", jo.xm7_1_2Panding_1 ==null?weixuanzhong:jo.xm7_1_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_1_2", jo.xm7_1_2Panding_1 ==null?weixuanzhong:jo.xm7_1_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_1_3", jo.xm7_1_2Panding_1 ==null?weixuanzhong:jo.xm7_1_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_2_1", jo.xm7_1_2Panding_2 ==null?weixuanzhong:jo.xm7_1_2Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_2_2", jo.xm7_1_2Panding_2 ==null?weixuanzhong:jo.xm7_1_2Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_2_3", jo.xm7_1_2Panding_2 ==null?weixuanzhong:jo.xm7_1_2Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_3_1", jo.xm7_1_2Panding_3 ==null?weixuanzhong:jo.xm7_1_2Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_3_2", jo.xm7_1_2Panding_3 ==null?weixuanzhong:jo.xm7_1_2Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_3_3", jo.xm7_1_2Panding_3 ==null?weixuanzhong:jo.xm7_1_2Panding_3 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_4_1", jo.xm7_1_2Panding_4 ==null?weixuanzhong:jo.xm7_1_2Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_4_2", jo.xm7_1_2Panding_4 ==null?weixuanzhong:jo.xm7_1_2Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_4_3", jo.xm7_1_2Panding_4 ==null?weixuanzhong:jo.xm7_1_2Panding_4 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_5_1", jo.xm7_1_2Panding_5 ==null?weixuanzhong:jo.xm7_1_2Panding_5 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_5_2", jo.xm7_1_2Panding_5 ==null?weixuanzhong:jo.xm7_1_2Panding_5 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_5_3", jo.xm7_1_2Panding_5 ==null?weixuanzhong:jo.xm7_1_2Panding_5 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_6_1", jo.xm7_1_2Panding_6 ==null?weixuanzhong:jo.xm7_1_2Panding_6 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_6_2", jo.xm7_1_2Panding_6 ==null?weixuanzhong:jo.xm7_1_2Panding_6 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_6_3", jo.xm7_1_2Panding_6 ==null?weixuanzhong:jo.xm7_1_2Panding_6 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_7_1", jo.xm7_1_2Panding_7 ==null?weixuanzhong:jo.xm7_1_2Panding_7 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_7_2", jo.xm7_1_2Panding_7 ==null?weixuanzhong:jo.xm7_1_2Panding_7 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_7_3", jo.xm7_1_2Panding_7 ==null?weixuanzhong:jo.xm7_1_2Panding_7 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_2Panding_8_0", jo.xm7_1_2Panding_8==null?"/":jo.xm7_1_2Panding_8 },
                        { "xm7_1_2Panding_9_0", jo.xm7_1_2Panding_9==null?"/":jo.xm7_1_2Panding_9 },
                        { "xm7_1_2Panding_10_0", jo.xm7_1_2Panding_10==null?"/":jo.xm7_1_2Panding_10 },
                        { "xm7_1_2Panding_11_0", jo.xm7_1_2Panding_11==null?"/":jo.xm7_1_2Panding_11 },
                        { "xm7_1_2Panding_12_0", jo.xm7_1_2Panding_12==null?"/":jo.xm7_1_2Panding_12 },
                        { "xm7_1_2Panding_13_0", jo.xm7_1_2Panding_13==null?"/":jo.xm7_1_2Panding_13 },
                        { "xm7_1_2Panding_14_0", jo.xm7_1_2Panding_14==null?"/":jo.xm7_1_2Panding_14 },

                        { "xm7_1_3Panding_1_1", jo.xm7_1_3Panding_1 ==null?weixuanzhong:jo.xm7_1_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_3Panding_1_2", jo.xm7_1_3Panding_1 ==null?weixuanzhong:jo.xm7_1_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_3Panding_1_3", jo.xm7_1_3Panding_1 ==null?weixuanzhong:jo.xm7_1_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_3Panding_2_0", jo.xm7_1_3Panding_2==null?"/":jo.xm7_1_3Panding_2 },

                        { "xm7_1_4Panding_1_1", jo.xm7_1_4Panding_1 ==null?weixuanzhong:jo.xm7_1_4Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_4Panding_1_2", jo.xm7_1_4Panding_1 ==null?weixuanzhong:jo.xm7_1_4Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_4Panding_1_3", jo.xm7_1_4Panding_1 ==null?weixuanzhong:jo.xm7_1_4Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_4Panding_2_0", jo.xm7_1_4Panding_2==null?"/":jo.xm7_1_4Panding_2 },
                        { "xm7_1_4Panding_3_0", jo.xm7_1_4Panding_3==null?"/":jo.xm7_1_4Panding_3 },
                        { "xm7_1_4Panding_4_0", jo.xm7_1_4Panding_4==null?"/":jo.xm7_1_4Panding_4 },
                        { "xm7_1_4Panding_5_0", jo.xm7_1_4Panding_5==null?"/":jo.xm7_1_4Panding_5 },
                        { "xm7_1_4Panding_6_0", jo.xm7_1_4Panding_6==null?"/":jo.xm7_1_4Panding_6 },
                        { "xm7_1_4Panding_7_0", jo.xm7_1_4Panding_7==null?"/":jo.xm7_1_4Panding_7 },
                        { "xm7_1_4Panding_8_0", jo.xm7_1_4Panding_8==null?"/":jo.xm7_1_4Panding_8 },
                        { "xm7_1_4Panding_9_0", jo.xm7_1_4Panding_9==null?"/":jo.xm7_1_4Panding_9 },
                        { "xm7_1_4Panding_10_0", jo.xm7_1_4Panding_10==null?"/":jo.xm7_1_4Panding_10 },
                        { "xm7_1_4Panding_11_0", jo.xm7_1_4Panding_11==null?"/":jo.xm7_1_4Panding_11 },

                        { "xm7_1_5Panding_1_1", jo.xm7_1_5Panding_1 ==null?weixuanzhong:jo.xm7_1_5Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_5Panding_1_2", jo.xm7_1_5Panding_1 ==null?weixuanzhong:jo.xm7_1_5Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_5Panding_1_3", jo.xm7_1_5Panding_1 ==null?weixuanzhong:jo.xm7_1_5Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_5Panding_2_1", jo.xm7_1_5Panding_2 ==null?weixuanzhong:jo.xm7_1_5Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_5Panding_2_2", jo.xm7_1_5Panding_2 ==null?weixuanzhong:jo.xm7_1_5Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_5Panding_2_3", jo.xm7_1_5Panding_2 ==null?weixuanzhong:jo.xm7_1_5Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_5Panding_3_0", jo.xm7_1_5Panding_3==null?"/":jo.xm7_1_5Panding_3 },
                        { "xm7_1_5Panding_4_0", jo.xm7_1_5Panding_4==null?"/":jo.xm7_1_5Panding_4 },
                        { "xm7_1_5Panding_5_0", jo.xm7_1_5Panding_5==null?"/":jo.xm7_1_5Panding_5 },
                        { "xm7_1_5Panding_6_0", jo.xm7_1_5Panding_6==null?"/":jo.xm7_1_5Panding_6 },
                        { "xm7_1_5Panding_7_0", jo.xm7_1_5Panding_7==null?"/":jo.xm7_1_5Panding_7 },
                        { "xm7_1_5Panding_8_0", jo.xm7_1_5Panding_8==null?"/":jo.xm7_1_5Panding_8 },
                        { "xm7_1_5Panding_9_0", jo.xm7_1_5Panding_9==null?"/":jo.xm7_1_5Panding_9 },
                        { "xm7_1_6Panding_1_1", jo.xm7_1_6Panding_1 ==null?weixuanzhong:jo.xm7_1_6Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_1_6Panding_1_2", jo.xm7_1_6Panding_1 ==null?weixuanzhong:jo.xm7_1_6Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_1_6Panding_1_3", jo.xm7_1_6Panding_1 ==null?weixuanzhong:jo.xm7_1_6Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_1_6Panding_2_0", jo.xm7_1_6Panding_2==null?"/":jo.xm7_1_6Panding_2 },
                        { "xm7_1_6Panding_3_0", jo.xm7_1_6Panding_3==null?"/":jo.xm7_1_6Panding_3 },
                        { "xm7_1_6Panding_4_0", jo.xm7_1_6Panding_4==null?"/":jo.xm7_1_6Panding_4 },
                        { "xm7_1_6Panding_5_0", jo.xm7_1_6Panding_5==null?"/":jo.xm7_1_6Panding_5 },
                        { "xm7_1_6Panding_6_0", jo.xm7_1_6Panding_6==null?"/":jo.xm7_1_6Panding_6 },
                        { "xm7_2_1Panding_1_1", jo.xm7_2_1Panding_1 ==null?weixuanzhong:jo.xm7_2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_1_2", jo.xm7_2_1Panding_1 ==null?weixuanzhong:jo.xm7_2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_1_3", jo.xm7_2_1Panding_1 ==null?weixuanzhong:jo.xm7_2_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_2_0", jo.xm7_2_1Panding_2==null?"/":jo.xm7_2_1Panding_2 },
                        { "xm7_2_1Panding_3_0", jo.xm7_2_1Panding_3==null?"/":jo.xm7_2_1Panding_3 },
                        { "xm7_2_1Panding_4_1", jo.xm7_2_1Panding_4==null?weixuanzhong:jo.xm7_2_1Panding_4.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_4_2", jo.xm7_2_1Panding_4==null?weixuanzhong:jo.xm7_2_1Panding_4.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_4_3", jo.xm7_2_1Panding_4==null?weixuanzhong:jo.xm7_2_1Panding_4.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_4_4", jo.xm7_2_1Panding_4==null?weixuanzhong:jo.xm7_2_1Panding_4.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm7_2_1Panding_5_0", jo.xm7_2_1Panding_5==null?"/":jo.xm7_2_1Panding_5 },

                        { "xm7_2_2Panding_1_1", jo.xm7_2_2Panding_1 ==null?weixuanzhong:jo.xm7_2_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_1_2", jo.xm7_2_2Panding_1 ==null?weixuanzhong:jo.xm7_2_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_1_3", jo.xm7_2_2Panding_1 ==null?weixuanzhong:jo.xm7_2_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_2_1", jo.xm7_2_2Panding_2 ==null?weixuanzhong:jo.xm7_2_2Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_2_2", jo.xm7_2_2Panding_2 ==null?weixuanzhong:jo.xm7_2_2Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_2_3", jo.xm7_2_2Panding_2 ==null?weixuanzhong:jo.xm7_2_2Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_3_1", jo.xm7_2_2Panding_3 ==null?weixuanzhong:jo.xm7_2_2Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_3_2", jo.xm7_2_2Panding_3 ==null?weixuanzhong:jo.xm7_2_2Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_3_3", jo.xm7_2_2Panding_3 ==null?weixuanzhong:jo.xm7_2_2Panding_3 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_4_1", jo.xm7_2_2Panding_4 ==null?weixuanzhong:jo.xm7_2_2Panding_4 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_4_2", jo.xm7_2_2Panding_4 ==null?weixuanzhong:jo.xm7_2_2Panding_4 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_4_3", jo.xm7_2_2Panding_4 ==null?weixuanzhong:jo.xm7_2_2Panding_4 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_5_1", jo.xm7_2_2Panding_5 ==null?weixuanzhong:jo.xm7_2_2Panding_5 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_5_2", jo.xm7_2_2Panding_5 ==null?weixuanzhong:jo.xm7_2_2Panding_5 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_5_3", jo.xm7_2_2Panding_5 ==null?weixuanzhong:jo.xm7_2_2Panding_5 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_6_1", jo.xm7_2_2Panding_6 ==null?weixuanzhong:jo.xm7_2_2Panding_6 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_6_2", jo.xm7_2_2Panding_6 ==null?weixuanzhong:jo.xm7_2_2Panding_6 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_6_3", jo.xm7_2_2Panding_6 ==null?weixuanzhong:jo.xm7_2_2Panding_6 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_7_1", jo.xm7_2_2Panding_7 ==null?weixuanzhong:jo.xm7_2_2Panding_7 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_7_2", jo.xm7_2_2Panding_7 ==null?weixuanzhong:jo.xm7_2_2Panding_7 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_7_3", jo.xm7_2_2Panding_7 ==null?weixuanzhong:jo.xm7_2_2Panding_7 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_2Panding_8_0", jo.xm7_2_2Panding_8==null?"/":jo.xm7_2_2Panding_8 },
                        { "xm7_2_2Panding_9_0", jo.xm7_2_2Panding_9==null?"/":jo.xm7_2_2Panding_9 },
                        { "xm7_2_2Panding_10_0", jo.xm7_2_2Panding_10==null?"/":jo.xm7_2_2Panding_10 },
                        { "xm7_2_2Panding_11_0", jo.xm7_2_2Panding_11==null?"/":jo.xm7_2_2Panding_11 },
                        { "xm7_2_2Panding_12_0", jo.xm7_2_2Panding_12==null?"/":jo.xm7_2_2Panding_12 },

                        { "xm7_2_3Panding_1_1", jo.xm7_2_3Panding_1 ==null?weixuanzhong:jo.xm7_2_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_3Panding_1_2", jo.xm7_2_3Panding_1 ==null?weixuanzhong:jo.xm7_2_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_3Panding_1_3", jo.xm7_2_3Panding_1 ==null?weixuanzhong:jo.xm7_2_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_3Panding_2_0", jo.xm7_2_3Panding_2==null?"/":jo.xm7_2_3Panding_2 },

                        { "xm7_2_4Panding_1_1", jo.xm7_2_4Panding_1 ==null?weixuanzhong:jo.xm7_2_4Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_4Panding_1_2", jo.xm7_2_4Panding_1 ==null?weixuanzhong:jo.xm7_2_4Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_4Panding_1_3", jo.xm7_2_4Panding_1 ==null?weixuanzhong:jo.xm7_2_4Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_4Panding_2_0", jo.xm7_2_4Panding_2==null?"/":jo.xm7_2_4Panding_2 },
                        { "xm7_2_4Panding_3_0", jo.xm7_2_4Panding_3==null?"/":jo.xm7_2_4Panding_3 },
                        { "xm7_2_4Panding_4_0", jo.xm7_2_4Panding_4==null?"/":jo.xm7_2_4Panding_4 },
                        { "xm7_2_4Panding_5_0", jo.xm7_2_4Panding_5==null?"/":jo.xm7_2_4Panding_5 },
                        { "xm7_2_4Panding_6_0", jo.xm7_2_4Panding_6==null?"/":jo.xm7_2_4Panding_6 },
                        { "xm7_2_4Panding_7_0", jo.xm7_2_4Panding_7==null?"/":jo.xm7_2_4Panding_7 },
                        { "xm7_2_4Panding_8_0", jo.xm7_2_4Panding_8==null?"/":jo.xm7_2_4Panding_8 },
                        { "xm7_2_4Panding_9_0", jo.xm7_2_4Panding_9==null?"/":jo.xm7_2_4Panding_9 },
                        { "xm7_2_4Panding_10_0", jo.xm7_2_4Panding_10==null?"/":jo.xm7_2_4Panding_10 },
                        { "xm7_2_4Panding_11_0", jo.xm7_2_4Panding_11==null?"/":jo.xm7_2_4Panding_11 },

                        { "xm7_2_5Panding_1_1", jo.xm7_2_5Panding_1 ==null?weixuanzhong:jo.xm7_2_5Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_5Panding_1_2", jo.xm7_2_5Panding_1 ==null?weixuanzhong:jo.xm7_2_5Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_5Panding_1_3", jo.xm7_2_5Panding_1 ==null?weixuanzhong:jo.xm7_2_5Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_5Panding_2_0", jo.xm7_2_5Panding_2==null?"/":jo.xm7_2_5Panding_2 },
                        { "xm7_2_5Panding_3_0", jo.xm7_2_5Panding_3==null?"/":jo.xm7_2_5Panding_3 },

                        { "xm7_2_6Panding_1_1", jo.xm7_2_6Panding_1 ==null?weixuanzhong:jo.xm7_2_6Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_6Panding_1_2", jo.xm7_2_6Panding_1 ==null?weixuanzhong:jo.xm7_2_6Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_6Panding_1_3", jo.xm7_2_6Panding_2 ==null?weixuanzhong:jo.xm7_2_6Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_6Panding_2_1", jo.xm7_2_6Panding_2 ==null?weixuanzhong:jo.xm7_2_6Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_6Panding_2_2", jo.xm7_2_6Panding_2 ==null?weixuanzhong:jo.xm7_2_6Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_6Panding_3_0", jo.xm7_2_6Panding_3==null?"/":jo.xm7_2_6Panding_3 },
                        { "xm7_2_6Panding_4_0", jo.xm7_2_6Panding_4==null?"/":jo.xm7_2_6Panding_4 },
                        { "xm7_2_6Panding_5_0", jo.xm7_2_6Panding_5==null?"/":jo.xm7_2_6Panding_5 },
                        { "xm7_2_6Panding_6_0", jo.xm7_2_6Panding_6==null?"/":jo.xm7_2_6Panding_6 },
                        { "xm7_2_6Panding_7_0", jo.xm7_2_6Panding_7==null?"/":jo.xm7_2_6Panding_7 },
                        { "xm7_2_6Panding_8_0", jo.xm7_2_6Panding_8==null?"/":jo.xm7_2_6Panding_8 },
                        { "xm7_2_6Panding_9_0", jo.xm7_2_6Panding_9==null?"/":jo.xm7_2_6Panding_9 },

                        { "xm7_2_7Panding_1_1", jo.xm7_2_7Panding_1 ==null?weixuanzhong:jo.xm7_2_7Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm7_2_7Panding_1_2", jo.xm7_2_7Panding_1 ==null?weixuanzhong:jo.xm7_2_7Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm7_2_7Panding_1_3", jo.xm7_2_7Panding_1 ==null?weixuanzhong:jo.xm7_2_7Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm7_2_7Panding_2_0", jo.xm7_2_7Panding_2==null?"/":jo.xm7_2_7Panding_2 },
                        { "xm7_2_7Panding_3_0", jo.xm7_2_7Panding_3==null?"/":jo.xm7_2_7Panding_3 },
                        { "xm7_2_7Panding_4_0", jo.xm7_2_7Panding_4==null?"/":jo.xm7_2_7Panding_4 },


                        { "xm8_1_1Panding_1_1", jo.xm8_1_1Panding_1 ==null?weixuanzhong:jo.xm8_1_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_1_1Panding_1_2", jo.xm8_1_1Panding_1 ==null?weixuanzhong:jo.xm8_1_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_1_1Panding_2_0", jo.xm8_1_1Panding_2==null?"/":jo.xm8_1_1Panding_2 },
                        { "xm8_1_1Panding_3_0", jo.xm8_1_1Panding_3==null?"/":jo.xm8_1_1Panding_3 },
                        { "xm8_1_1Panding_4_0", jo.xm8_1_1Panding_4==null?"/":jo.xm8_1_1Panding_4 },
                        { "xm8_1_1Panding_5_0", jo.xm8_1_1Panding_5==null?"/":jo.xm8_1_1Panding_5 },
                        { "xm8_1_1Panding_6_0", jo.xm8_1_1Panding_6==null?"/":jo.xm8_1_1Panding_6 },
                        { "xm8_1_1Panding_7_0", jo.xm8_1_1Panding_7==null?"/":jo.xm8_1_1Panding_7 },
                        { "xm8_1_1Panding_8_0", jo.xm8_1_1Panding_8==null?"/":jo.xm8_1_1Panding_8 },
                        { "xm8_1_1Panding_9_0", jo.xm8_1_1Panding_9==null?"/":jo.xm8_1_1Panding_9 },
                        { "xm8_1_1Panding_10_0", jo.xm8_1_1Panding_10==null?"/":jo.xm8_1_1Panding_10 },
                        { "xm8_1_2Panding_1_1", jo.xm8_1_2Panding_1 ==null?weixuanzhong:jo.xm8_1_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_1_2Panding_1_2", jo.xm8_1_2Panding_1 ==null?weixuanzhong:jo.xm8_1_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_1_2Panding_2_0", jo.xm8_1_2Panding_2==null?"/":jo.xm8_1_2Panding_2 },
                        { "xm8_1_2Panding_3_0", jo.xm8_1_2Panding_3==null?"/":jo.xm8_1_2Panding_3 },
                        { "xm8_1_2Panding_4_0", jo.xm8_1_2Panding_4==null?"/":jo.xm8_1_2Panding_4 },
                        { "xm8_1_2Panding_5_0", jo.xm8_1_2Panding_5==null?"/":jo.xm8_1_2Panding_5 },
                        { "xm8_1_2Panding_6_0", jo.xm8_1_2Panding_6==null?"/":jo.xm8_1_2Panding_6 },
                        { "xm8_1_2Panding_7_0", jo.xm8_1_2Panding_7==null?"/":jo.xm8_1_2Panding_7 },
                        { "xm8_1_2Panding_8_0", jo.xm8_1_2Panding_8==null?"/":jo.xm8_1_2Panding_8 },
                        { "xm8_1_3Panding_1_1", jo.xm8_1_3Panding_1 ==null?weixuanzhong:jo.xm8_1_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_1_2", jo.xm8_1_3Panding_1 ==null?weixuanzhong:jo.xm8_1_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_1_3", jo.xm8_1_3Panding_1 ==null?weixuanzhong:jo.xm8_1_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_2_1", jo.xm8_1_3Panding_2 ==null?weixuanzhong:jo.xm8_1_3Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_2_2", jo.xm8_1_3Panding_2 ==null?weixuanzhong:jo.xm8_1_3Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_2_3", jo.xm8_1_3Panding_2 ==null?weixuanzhong:jo.xm8_1_3Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_3_1", jo.xm8_1_3Panding_3 ==null?weixuanzhong:jo.xm8_1_3Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_3_2", jo.xm8_1_3Panding_3 ==null?weixuanzhong:jo.xm8_1_3Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_3_3", jo.xm8_1_3Panding_3 ==null?weixuanzhong:jo.xm8_1_3Panding_3 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_1_3Panding_4_0", jo.xm8_1_3Panding_4==null?"/":jo.xm8_1_3Panding_4 },
                        { "xm8_2_1Panding_1_1", jo.xm8_2_1Panding_1 ==null?weixuanzhong:jo.xm8_2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_1Panding_1_2", jo.xm8_2_1Panding_1 ==null?weixuanzhong:jo.xm8_2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_1Panding_1_3", jo.xm8_2_1Panding_1 ==null?weixuanzhong:jo.xm8_2_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_1Panding_2_0", jo.xm8_2_1Panding_2==null?"/":jo.xm8_2_1Panding_2 },
                        { "xm8_2_1Panding_3_0", jo.xm8_2_1Panding_3==null?"/":jo.xm8_2_1Panding_3 },
                        { "xm8_2_1Panding_4_0", jo.xm8_2_1Panding_4==null?"/":jo.xm8_2_1Panding_4 },
                        { "xm8_2_1Panding_5_0", jo.xm8_2_1Panding_5==null?"/":jo.xm8_2_1Panding_5 },
                        { "xm8_2_1Panding_6_0", jo.xm8_2_1Panding_6==null?"/":jo.xm8_2_1Panding_6 },
                        { "xm8_2_1Panding_7_0", jo.xm8_2_1Panding_7==null?"/":jo.xm8_2_1Panding_7 },
                        { "xm8_2_1Panding_8_1", jo.xm8_2_1Panding_8==null?weixuanzhong:jo.xm8_2_1Panding_8.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_1Panding_8_2", jo.xm8_2_1Panding_8==null?weixuanzhong:jo.xm8_2_1Panding_8.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_1Panding_8_3", jo.xm8_2_1Panding_8==null?weixuanzhong:jo.xm8_2_1Panding_8.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_1Panding_9_0", jo.xm8_2_1Panding_9==null?"/":jo.xm8_2_1Panding_9 },

                        { "xm8_2_2Panding_1_1", jo.xm8_2_2Panding_1 ==null?weixuanzhong:jo.xm8_2_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_2Panding_1_2", jo.xm8_2_2Panding_1 ==null?weixuanzhong:jo.xm8_2_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_2Panding_1_3", jo.xm8_2_2Panding_1 ==null?weixuanzhong:jo.xm8_2_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_2Panding_2_1", jo.xm8_2_2Panding_2 ==null?weixuanzhong:jo.xm8_2_2Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_2Panding_2_2", jo.xm8_2_2Panding_2 ==null?weixuanzhong:jo.xm8_2_2Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_2Panding_3_0", jo.xm8_2_2Panding_3==null?"/":jo.xm8_2_2Panding_3 },
                        { "xm8_2_2Panding_4_0", jo.xm8_2_2Panding_4==null?"/":jo.xm8_2_2Panding_4 },
                        { "xm8_2_3Panding_1_1", jo.xm8_2_3Panding_1 ==null?weixuanzhong:jo.xm8_2_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_3Panding_1_2", jo.xm8_2_3Panding_1 ==null?weixuanzhong:jo.xm8_2_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_3Panding_1_3", jo.xm8_2_3Panding_1 ==null?weixuanzhong:jo.xm8_2_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_3Panding_2_0", jo.xm8_2_3Panding_2==null?"/":jo.xm8_2_3Panding_2 },
                        { "xm8_2_3Panding_3_0", jo.xm8_2_3Panding_3==null?"/":jo.xm8_2_3Panding_3 },
                        { "xm8_2_3Panding_4_0", jo.xm8_2_3Panding_4==null?"/":jo.xm8_2_3Panding_4 },
                        { "xm8_2_3Panding_5_0", jo.xm8_2_3Panding_5==null?"/":jo.xm8_2_3Panding_5 },
                        { "xm8_2_3Panding_6_0", jo.xm8_2_3Panding_6==null?"/":jo.xm8_2_3Panding_6 },
                        { "xm8_2_3Panding_7_0", jo.xm8_2_3Panding_7==null?"/":jo.xm8_2_3Panding_7 },
                        { "xm8_2_3Panding_8_0", jo.xm8_2_3Panding_8==null?"/":jo.xm8_2_3Panding_8 },
                        { "xm8_2_3Panding_9_0", jo.xm8_2_3Panding_9==null?"/":jo.xm8_2_3Panding_9 },
                        { "xm8_2_3Panding_10_0", jo.xm8_2_3Panding_10==null?"/":jo.xm8_2_3Panding_10 },
                        { "xm8_2_3Panding_11_0", jo.xm8_2_3Panding_11==null?"/":jo.xm8_2_3Panding_11 },
                        { "xm8_2_3Panding_12_0", jo.xm8_2_3Panding_12==null?"/":jo.xm8_2_3Panding_12 },
                        { "xm8_2_3Panding_13_0", jo.xm8_2_3Panding_13==null?"/":jo.xm8_2_3Panding_13 },
                        { "xm8_2_3Panding_14_0", jo.xm8_2_3Panding_14==null?"/":jo.xm8_2_3Panding_14 },
                        { "xm8_2_4Panding_1_1", jo.xm8_2_4Panding_1 ==null?weixuanzhong:jo.xm8_2_4Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_1_2", jo.xm8_2_4Panding_1 ==null?weixuanzhong:jo.xm8_2_4Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_1_3", jo.xm8_2_4Panding_1 ==null?weixuanzhong:jo.xm8_2_4Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_2_1", jo.xm8_2_4Panding_2==null?weixuanzhong:jo.xm8_2_4Panding_2.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_2_2", jo.xm8_2_4Panding_2==null?weixuanzhong:jo.xm8_2_4Panding_2.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_2_3", jo.xm8_2_4Panding_2==null?weixuanzhong:jo.xm8_2_4Panding_2.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_2_4", jo.xm8_2_4Panding_2==null?weixuanzhong:jo.xm8_2_4Panding_2.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_2_5", jo.xm8_2_4Panding_2==null?weixuanzhong:jo.xm8_2_4Panding_2.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_2_6", jo.xm8_2_4Panding_2==null?weixuanzhong:jo.xm8_2_4Panding_2.IndexOf("06") != -1 ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_3_1", jo.xm8_2_4Panding_3 ==null?weixuanzhong:jo.xm8_2_4Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_3_2", jo.xm8_2_4Panding_3 ==null?weixuanzhong:jo.xm8_2_4Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_3_3", jo.xm8_2_4Panding_3 ==null?weixuanzhong:jo.xm8_2_4Panding_3 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_4_0", jo.xm8_2_4Panding_4==null?"/":jo.xm8_2_4Panding_4 },
                        { "xm8_2_4Panding_5_0", jo.xm8_2_4Panding_5==null?"/":jo.xm8_2_4Panding_5 },
                        { "xm8_2_4Panding_6_1", jo.xm8_2_4Panding_6 ==null?weixuanzhong:jo.xm8_2_4Panding_6 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_6_2", jo.xm8_2_4Panding_6 ==null?weixuanzhong:jo.xm8_2_4Panding_6 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_6_3", jo.xm8_2_4Panding_6 ==null?weixuanzhong:jo.xm8_2_4Panding_6 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_4Panding_7_0", jo.xm8_2_4Panding_7==null?"/":jo.xm8_2_4Panding_7 },
                        { "xm8_2_5Panding_1_1", jo.xm8_2_5Panding_1 ==null?weixuanzhong:jo.xm8_2_5Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_5Panding_1_2", jo.xm8_2_5Panding_1 ==null?weixuanzhong:jo.xm8_2_5Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_5Panding_1_3", jo.xm8_2_5Panding_1 ==null?weixuanzhong:jo.xm8_2_5Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_5Panding_2_0", jo.xm8_2_5Panding_2==null?"/":jo.xm8_2_5Panding_2 },
                        { "xm8_2_5Panding_3_1", jo.xm8_2_5Panding_3 ==null?weixuanzhong:jo.xm8_2_5Panding_3 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_5Panding_3_2", jo.xm8_2_5Panding_3 ==null?weixuanzhong:jo.xm8_2_5Panding_3 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_5Panding_3_3", jo.xm8_2_5Panding_3 ==null?weixuanzhong:jo.xm8_2_5Panding_3 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_5Panding_4_0", jo.xm8_2_5Panding_4==null?"/":jo.xm8_2_5Panding_4 },
                        { "xm8_2_6Panding_1_1", jo.xm8_2_6Panding_1 ==null?weixuanzhong:jo.xm8_2_6Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm8_2_6Panding_1_2", jo.xm8_2_6Panding_1 ==null?weixuanzhong:jo.xm8_2_6Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm8_2_6Panding_1_3", jo.xm8_2_6Panding_1 ==null?weixuanzhong:jo.xm8_2_6Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm8_2_6Panding_2_0", jo.xm8_2_6Panding_2==null?"/":jo.xm8_2_6Panding_2 },



                        { "xm9_1Panding_1_1", jo.xm9_1Panding_1 ==null?weixuanzhong:jo.xm9_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_1Panding_1_2", jo.xm9_1Panding_1 ==null?weixuanzhong:jo.xm9_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_1Panding_1_3", jo.xm9_1Panding_1 ==null?weixuanzhong:jo.xm9_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_1Panding_2_0", jo.xm9_1Panding_2==null?"/":jo.xm9_1Panding_2 },
                        { "xm9_1Panding_3_0", jo.xm9_1Panding_3==null?"/":jo.xm9_1Panding_3 },
                        { "xm9_1Panding_4_1", jo.xm9_1Panding_4==null?weixuanzhong:jo.xm9_1Panding_4.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_1Panding_4_2", jo.xm9_1Panding_4==null?weixuanzhong:jo.xm9_1Panding_4.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_1Panding_4_3", jo.xm9_1Panding_4==null?weixuanzhong:jo.xm9_1Panding_4.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_1Panding_4_4", jo.xm9_1Panding_4==null?weixuanzhong:jo.xm9_1Panding_4.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                                { "xm9_1Panding_5_0", jo.xm9_1Panding_5==null?"/":jo.xm9_1Panding_5 },

                        { "xm9_2_1Panding_1_1", jo.xm9_2_1Panding_1 ==null?weixuanzhong:jo.xm9_2_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_2_1Panding_1_2", jo.xm9_2_1Panding_1 ==null?weixuanzhong:jo.xm9_2_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_2_1Panding_1_3", jo.xm9_2_1Panding_1 ==null?weixuanzhong:jo.xm9_2_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_2_1Panding_2_0", jo.xm9_2_1Panding_2==null?"/":jo.xm9_2_1Panding_2 },

                        { "xm9_2_2Panding_1_1", jo.xm9_2_2Panding_1 ==null?weixuanzhong:jo.xm9_2_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_2_2Panding_1_2", jo.xm9_2_2Panding_1 ==null?weixuanzhong:jo.xm9_2_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_2_2Panding_1_3", jo.xm9_2_2Panding_1 ==null?weixuanzhong:jo.xm9_2_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_2_2Panding_2_0", jo.xm9_2_2Panding_2==null?"/":jo.xm9_2_2Panding_2 },

                        { "xm9_3_1Panding_1_1", jo.xm9_3_1Panding_1 ==null?weixuanzhong:jo.xm9_3_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_3_1Panding_1_2", jo.xm9_3_1Panding_1 ==null?weixuanzhong:jo.xm9_3_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_3_1Panding_1_3", jo.xm9_3_1Panding_1 ==null?weixuanzhong:jo.xm9_3_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_3_1Panding_2_0", jo.xm9_3_1Panding_2==null?"/":jo.xm9_3_1Panding_2 },
                        { "xm9_3_1Panding_3_0", jo.xm9_3_1Panding_3==null?"/":jo.xm9_3_1Panding_3 },
                        { "xm9_3_2Panding_1_1", jo.xm9_3_2Panding_1 ==null?weixuanzhong:jo.xm9_3_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_3_2Panding_1_2", jo.xm9_3_2Panding_1 ==null?weixuanzhong:jo.xm9_3_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_3_2Panding_1_3", jo.xm9_3_2Panding_1 ==null?weixuanzhong:jo.xm9_3_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_3_2Panding_2_0", jo.xm9_3_2Panding_2==null?"/":jo.xm9_3_2Panding_2 },

                        { "xm9_4_1Panding_1_1", jo.xm9_4_1Panding_1 ==null?weixuanzhong:jo.xm9_4_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_1_2", jo.xm9_4_1Panding_1 ==null?weixuanzhong:jo.xm9_4_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_1_3", jo.xm9_4_1Panding_1 ==null?weixuanzhong:jo.xm9_4_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_2_1", jo.xm9_4_1Panding_2==null?weixuanzhong:jo.xm9_4_1Panding_2.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_2_2", jo.xm9_4_1Panding_2==null?weixuanzhong:jo.xm9_4_1Panding_2.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_2_3", jo.xm9_4_1Panding_2==null?weixuanzhong:jo.xm9_4_1Panding_2.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_2_4", jo.xm9_4_1Panding_2==null?weixuanzhong:jo.xm9_4_1Panding_2.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_2_5", jo.xm9_4_1Panding_2==null?weixuanzhong:jo.xm9_4_1Panding_2.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_1Panding_3_0", jo.xm9_4_1Panding_3==null?"/":jo.xm9_4_1Panding_3 },
                        { "xm9_4_1Panding_4_0", jo.xm9_4_1Panding_4==null?"/":jo.xm9_4_1Panding_4 },

                        { "xm9_4_2Panding_1_1", jo.xm9_4_2Panding_1 ==null?weixuanzhong:jo.xm9_4_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_1_2", jo.xm9_4_2Panding_1 ==null?weixuanzhong:jo.xm9_4_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_1_3", jo.xm9_4_2Panding_1 ==null?weixuanzhong:jo.xm9_4_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_2_1", jo.xm9_4_2Panding_2==null?weixuanzhong:jo.xm9_4_2Panding_2.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_2_2", jo.xm9_4_2Panding_2==null?weixuanzhong:jo.xm9_4_2Panding_2.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_2_3", jo.xm9_4_2Panding_2==null?weixuanzhong:jo.xm9_4_2Panding_2.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_2_4", jo.xm9_4_2Panding_2==null?weixuanzhong:jo.xm9_4_2Panding_2.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_2_5", jo.xm9_4_2Panding_2==null?weixuanzhong:jo.xm9_4_2Panding_2.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_2Panding_3_0", jo.xm9_4_2Panding_3==null?"/":jo.xm9_4_2Panding_3 },
                        { "xm9_4_2Panding_4_0", jo.xm9_4_2Panding_4==null?"/":jo.xm9_4_2Panding_4 },

                        { "xm9_4_3Panding_1_1", jo.xm9_4_3Panding_1 ==null?weixuanzhong:jo.xm9_4_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_1_2", jo.xm9_4_3Panding_1 ==null?weixuanzhong:jo.xm9_4_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_1_3", jo.xm9_4_3Panding_1 ==null?weixuanzhong:jo.xm9_4_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_2_1", jo.xm9_4_3Panding_2==null?weixuanzhong:jo.xm9_4_3Panding_2.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_2_2", jo.xm9_4_3Panding_2==null?weixuanzhong:jo.xm9_4_3Panding_2.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_2_3", jo.xm9_4_3Panding_2==null?weixuanzhong:jo.xm9_4_3Panding_2.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_2_4", jo.xm9_4_3Panding_2==null?weixuanzhong:jo.xm9_4_3Panding_2.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_2_5", jo.xm9_4_3Panding_2==null?weixuanzhong:jo.xm9_4_3Panding_2.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_3Panding_3_0", jo.xm9_4_3Panding_3==null?"/":jo.xm9_4_3Panding_3 },
                        { "xm9_4_3Panding_4_0", jo.xm9_4_3Panding_4==null?"/":jo.xm9_4_3Panding_4 },

                        { "xm9_4_4Panding_1_1", jo.xm9_4_4Panding_1 ==null?weixuanzhong:jo.xm9_4_4Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_1_2", jo.xm9_4_4Panding_1 ==null?weixuanzhong:jo.xm9_4_4Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_1_3", jo.xm9_4_4Panding_1 ==null?weixuanzhong:jo.xm9_4_4Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_2_1", jo.xm9_4_4Panding_2==null?weixuanzhong:jo.xm9_4_4Panding_2.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_2_2", jo.xm9_4_4Panding_2==null?weixuanzhong:jo.xm9_4_4Panding_2.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_2_3", jo.xm9_4_4Panding_2==null?weixuanzhong:jo.xm9_4_4Panding_2.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_2_4", jo.xm9_4_4Panding_2==null?weixuanzhong:jo.xm9_4_4Panding_2.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_2_5", jo.xm9_4_4Panding_2==null?weixuanzhong:jo.xm9_4_4Panding_2.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_4_4Panding_3_0", jo.xm9_4_4Panding_3==null?"/":jo.xm9_4_4Panding_3 },
                        { "xm9_4_4Panding_4_0", jo.xm9_4_4Panding_4==null?"/":jo.xm9_4_4Panding_4 },

                        { "xm9_5Panding_1_1", jo.xm9_5Panding_1 ==null?weixuanzhong:jo.xm9_5Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_5Panding_1_2", jo.xm9_5Panding_1 ==null?weixuanzhong:jo.xm9_5Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_5Panding_1_3", jo.xm9_5Panding_1 ==null?weixuanzhong:jo.xm9_5Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_5Panding_2_1", jo.xm9_5Panding_2 ==null?weixuanzhong:jo.xm9_5Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_5Panding_2_2", jo.xm9_5Panding_2 ==null?weixuanzhong:jo.xm9_5Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_5Panding_2_3", jo.xm9_5Panding_2 ==null?weixuanzhong:jo.xm9_5Panding_2 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_5Panding_3_0", jo.xm9_5Panding_3==null?"/":jo.xm9_5Panding_3 },
                        { "xm9_5Panding_4_0", jo.xm9_5Panding_4==null?"/":jo.xm9_5Panding_4 },
                        { "xm9_5Panding_5_0", jo.xm9_5Panding_5==null?"/":jo.xm9_5Panding_5 },
                        { "xm9_5Panding_6_0", jo.xm9_5Panding_6==null?"/":jo.xm9_5Panding_6 },
                        { "xm9_5Panding_7_0", jo.xm9_5Panding_7==null?"/":jo.xm9_5Panding_7 },
                        { "xm9_5Panding_8_0", jo.xm9_5Panding_8==null?"/":jo.xm9_5Panding_8 },
                        { "xm9_5Panding_9_0", jo.xm9_5Panding_9==null?"/":jo.xm9_5Panding_9 },
                        { "xm9_5Panding_10_0", jo.xm9_5Panding_10==null?"/":jo.xm9_5Panding_10 },
                        { "xm9_5Panding_11_0", jo.xm9_5Panding_11==null?"/":jo.xm9_5Panding_11 },

                        { "xm9_6_1Panding_1_1", jo.xm9_6_1Panding_1 ==null?weixuanzhong:jo.xm9_6_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_6_1Panding_1_2", jo.xm9_6_1Panding_1 ==null?weixuanzhong:jo.xm9_6_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_6_1Panding_1_3", jo.xm9_6_1Panding_1 ==null?weixuanzhong:jo.xm9_6_1Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_6_1Panding_2_0", jo.xm9_6_1Panding_2==null?"/":jo.xm9_6_1Panding_2 },

                        { "xm9_6_2Panding_1_1", jo.xm9_6_2Panding_1 ==null?weixuanzhong:jo.xm9_6_2Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_6_2Panding_1_2", jo.xm9_6_2Panding_1 ==null?weixuanzhong:jo.xm9_6_2Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_6_2Panding_1_3", jo.xm9_6_2Panding_1 ==null?weixuanzhong:jo.xm9_6_2Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_6_2Panding_2_0", jo.xm9_6_2Panding_2==null?"/":jo.xm9_6_2Panding_2 },
                        { "xm9_6_2Panding_3_0", jo.xm9_6_2Panding_3==null?"/":jo.xm9_6_2Panding_3 },

                        { "xm9_6_3Panding_1_1", jo.xm9_6_3Panding_1 ==null?weixuanzhong:jo.xm9_6_3Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_6_3Panding_1_2", jo.xm9_6_3Panding_1 ==null?weixuanzhong:jo.xm9_6_3Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_6_3Panding_1_3", jo.xm9_6_3Panding_1 ==null?weixuanzhong:jo.xm9_6_3Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_6_3Panding_2_0", jo.xm9_6_3Panding_2==null?"/":jo.xm9_6_3Panding_2 },
                        { "xm9_6_3Panding_3_0", jo.xm9_6_3Panding_3==null?"/":jo.xm9_6_3Panding_3 },

                        { "xm9_6_4Panding_1_1", jo.xm9_6_4Panding_1 ==null?weixuanzhong:jo.xm9_6_4Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_6_4Panding_1_2", jo.xm9_6_4Panding_1 ==null?weixuanzhong:jo.xm9_6_4Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_6_4Panding_1_3", jo.xm9_6_4Panding_1 ==null?weixuanzhong:jo.xm9_6_4Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_6_4Panding_2_0", jo.xm9_6_4Panding_2==null?"/":jo.xm9_6_4Panding_2 },
                        { "xm9_6_4Panding_3_0", jo.xm9_6_4Panding_3==null?"/":jo.xm9_6_4Panding_3 },
                        { "xm9_6_4Panding_4_0", jo.xm9_6_4Panding_4==null?"/":jo.xm9_6_4Panding_4 },

                        { "xm9_6_5Panding_1_1", jo.xm9_6_5Panding_1 ==null?weixuanzhong:jo.xm9_6_5Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_6_5Panding_1_2", jo.xm9_6_5Panding_1 ==null?weixuanzhong:jo.xm9_6_5Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_6_5Panding_1_3", jo.xm9_6_5Panding_1 ==null?weixuanzhong:jo.xm9_6_5Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_6_5Panding_2_0", jo.xm9_6_5Panding_2==null?"/":jo.xm9_6_5Panding_2 },

                        { "xm9_7_1Panding_1_1", jo.xm9_7_1Panding_1 ==null?weixuanzhong:jo.xm9_7_1Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_7_1Panding_1_2", jo.xm9_7_1Panding_1 ==null?weixuanzhong:jo.xm9_7_1Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_7_1Panding_2_1", jo.xm9_7_1Panding_2 ==null?weixuanzhong:jo.xm9_7_1Panding_2 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_7_1Panding_2_2", jo.xm9_7_1Panding_2 ==null?weixuanzhong:jo.xm9_7_1Panding_2 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_7_1Panding_3_0", jo.xm9_7_1Panding_3==null?"/":jo.xm9_7_1Panding_3 },
                        { "xm9_7_1Panding_4_0", jo.xm9_7_1Panding_4==null?"/":jo.xm9_7_1Panding_4 },
                        { "xm9_7_1Panding_5_0", jo.xm9_7_1Panding_5==null?"/":jo.xm9_7_1Panding_5 },
                        { "xm9_7_1Panding_6_0", jo.xm9_7_1Panding_6==null?"/":jo.xm9_7_1Panding_6 },
                        { "xm9_7_1Panding_7_0", jo.xm9_7_1Panding_7==null?"/":jo.xm9_7_1Panding_7 },
                        { "xm9_7_1Panding_8_0", jo.xm9_7_1Panding_8==null?"/":jo.xm9_7_1Panding_8 },
                        { "xm9_7_1Panding_9_1", jo.xm9_7_1Panding_9 ==null?weixuanzhong:jo.xm9_7_1Panding_9 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_7_1Panding_9_2", jo.xm9_7_1Panding_9 ==null?weixuanzhong:jo.xm9_7_1Panding_9 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_7_1Panding_10_0", jo.xm9_7_1Panding_10==null?"/":jo.xm9_7_1Panding_10 },

                        { "xm9_7_2Panding_1_1", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("01") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_2", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("02") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_3", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("03") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_4", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("04") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_5", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("05") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_6", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("06") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_7", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("07") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_8", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("08") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_9", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("09") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_1_10", jo.xm9_7_2Panding_1==null?weixuanzhong:jo.xm9_7_2Panding_1.IndexOf("10") != -1 ? xuanzhong : weixuanzhong },
                        { "xm9_7_2Panding_2_0", jo.xm9_7_2Panding_2==null?"/":jo.xm9_7_2Panding_2 },

                        { "xm9_8Panding_1_1", jo.xm9_8Panding_1 ==null?weixuanzhong:jo.xm9_8Panding_1 == "是" ? xuanzhong : weixuanzhong },
                        { "xm9_8Panding_1_2", jo.xm9_8Panding_1 ==null?weixuanzhong:jo.xm9_8Panding_1 == "否" ? xuanzhong : weixuanzhong },
                        { "xm9_8Panding_1_3", jo.xm9_8Panding_1 ==null?weixuanzhong:jo.xm9_8Panding_1 == "欠" ? xuanzhong : weixuanzhong },
                        { "xm9_8Panding_2_0", jo.xm9_8Panding_2==null?"/":jo.xm9_8Panding_2 },
                        { "xm9_8Panding_3_0", jo.xm9_8Panding_3==null?"/":jo.xm9_8Panding_3 },
                        { "xm9_8Panding_4_0", jo.xm9_8Panding_4==null?"/":jo.xm9_8Panding_4 },
                        { "xm9_8Panding_5_0", jo.xm9_8Panding_5==null?"/":jo.xm9_8Panding_5 },
                        { "xm9_8Panding_6_0", jo.xm9_8Panding_6==null?"/":jo.xm9_8Panding_6 },


                        {"xm10_1Panding_1_1",jo.xm10_1Panding_1==null?weixuanzhong:jo.xm10_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_1_2",jo.xm10_1Panding_1==null?weixuanzhong:jo.xm10_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_1_3",jo.xm10_1Panding_1==null?weixuanzhong:jo.xm10_1Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_2_1",jo.xm10_1Panding_2==null?weixuanzhong:jo.xm10_1Panding_2.IndexOf("01")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_2_2",jo.xm10_1Panding_2==null?weixuanzhong:jo.xm10_1Panding_2.IndexOf("02")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_2_3",jo.xm10_1Panding_2==null?weixuanzhong:jo.xm10_1Panding_2.IndexOf("03")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_2_4",jo.xm10_1Panding_2==null?weixuanzhong:jo.xm10_1Panding_2.IndexOf("04")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_3_0",jo.xm10_1Panding_3==null?"/":jo.xm10_1Panding_3},
                        {"xm10_1Panding_4_0",jo.xm10_1Panding_4==null?"/":jo.xm10_1Panding_4},
                        {"xm10_1Panding_5_0",jo.xm10_1Panding_5==null?"/":jo.xm10_1Panding_5},

                        {"xm10_2Panding_1_1",jo.xm10_2Panding_1==null?weixuanzhong:jo.xm10_2Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm10_2Panding_1_2",jo.xm10_2Panding_1==null?weixuanzhong:jo.xm10_2Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm10_2Panding_1_3",jo.xm10_2Panding_1==null?weixuanzhong:jo.xm10_2Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm10_2Panding_2_0",jo.xm10_2Panding_2==null?"/":jo.xm10_2Panding_2},
                        {"xm10_2Panding_3_0",jo.xm10_2Panding_3==null?"/":jo.xm10_2Panding_3},
                        {"xm10_2Panding_4_0",jo.xm10_2Panding_4==null?"/":jo.xm10_2Panding_4},
                        {"xm10_2Panding_5_0",jo.xm10_2Panding_5==null?"/":jo.xm10_2Panding_5},
                        {"xm10_2Panding_6_0",jo.xm10_2Panding_6==null?"/":jo.xm10_2Panding_6},
                        {"xm10_2Panding_7_0",jo.xm10_2Panding_7==null?"/":jo.xm10_2Panding_7},

                        {"xm10_3Panding_1_1",jo.xm10_3Panding_1==null?weixuanzhong:jo.xm10_3Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm10_3Panding_1_2",jo.xm10_3Panding_1==null?weixuanzhong:jo.xm10_3Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm10_3Panding_1_3",jo.xm10_3Panding_1==null?weixuanzhong:jo.xm10_3Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm10_3Panding_2_0",jo.xm10_3Panding_2==null?"/":jo.xm10_3Panding_2},

                        {"xm10_4Panding_1_1",jo.xm10_4Panding_1==null?weixuanzhong:jo.xm10_4Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm10_4Panding_1_2",jo.xm10_4Panding_1==null?weixuanzhong:jo.xm10_4Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm10_4Panding_1_3",jo.xm10_4Panding_1==null?weixuanzhong:jo.xm10_4Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm10_4Panding_2_0",jo.xm10_4Panding_2==null?"/":jo.xm10_4Panding_2},

                        {"xm10_5Panding_1_1",jo.xm10_5Panding_1==null?weixuanzhong:jo.xm10_5Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_1_2",jo.xm10_5Panding_1==null?weixuanzhong:jo.xm10_5Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_1_3",jo.xm10_5Panding_1==null?weixuanzhong:jo.xm10_5Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_2_1",jo.xm10_5Panding_2==null?weixuanzhong:jo.xm10_5Panding_2=="是"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_2_2",jo.xm10_5Panding_2==null?weixuanzhong:jo.xm10_5Panding_2=="否"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_2_3",jo.xm10_5Panding_2==null?weixuanzhong:jo.xm10_5Panding_2=="欠"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_3_1",jo.xm10_5Panding_3==null?weixuanzhong:jo.xm10_5Panding_3.IndexOf("01")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_3_2",jo.xm10_5Panding_3==null?weixuanzhong:jo.xm10_5Panding_3.IndexOf("02")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_3_3",jo.xm10_5Panding_3==null?weixuanzhong:jo.xm10_5Panding_3.IndexOf("03")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_3_4",jo.xm10_5Panding_3==null?weixuanzhong:jo.xm10_5Panding_3.IndexOf("04")!=-1?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_4_0",jo.xm10_5Panding_4==null?"/":jo.xm10_5Panding_4},
                        {"xm10_5Panding_5_0",jo.xm10_5Panding_5==null?"/":jo.xm10_5Panding_5},
                        {"xm10_5Panding_6_0",jo.xm10_5Panding_6==null?"/":jo.xm10_5Panding_6},
                        {"xm10_5Panding_7_0",jo.xm10_5Panding_7==null?"/":jo.xm10_5Panding_7},
                        {"xm10_5Panding_8_0",jo.xm10_5Panding_8==null?"/":jo.xm10_5Panding_8},
                        {"xm10_5Panding_9_0",jo.xm10_5Panding_9==null?"/":jo.xm10_5Panding_9},
                        {"xm10_5Panding_10_0",jo.xm10_5Panding_10==null?"/":jo.xm10_5Panding_10},

                        {"xm11_1Panding_1_1",jo.xm11_1Panding_1==null?weixuanzhong:jo.xm11_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm11_1Panding_1_2",jo.xm11_1Panding_1==null?weixuanzhong:jo.xm11_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm11_1Panding_1_3",jo.xm11_1Panding_1==null?weixuanzhong:jo.xm11_1Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm11_1Panding_2_0",jo.xm11_1Panding_2==null?"/":jo.xm11_1Panding_2},
                        {"xm11_1Panding_3_0",jo.xm11_1Panding_3==null?"/":jo.xm11_1Panding_3},
                        {"xm11_1Panding_4_0",jo.xm11_1Panding_4==null?"/":jo.xm11_1Panding_4},

                        {"xm11_2Panding_1_1",jo.xm11_2Panding_1==null?weixuanzhong:jo.xm11_2Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm11_2Panding_1_2",jo.xm11_2Panding_1==null?weixuanzhong:jo.xm11_2Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm11_2Panding_2_0",jo.xm11_2Panding_2==null?"/":jo.xm11_2Panding_2},
                        {"xm11_2Panding_3_0",jo.xm11_2Panding_3==null?"/":jo.xm11_2Panding_3},

                        {"xm11_3Panding_1_1",jo.xm11_3Panding_1==null?weixuanzhong:jo.xm11_3Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm11_3Panding_1_2",jo.xm11_3Panding_1==null?weixuanzhong:jo.xm11_3Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm11_3Panding_1_3",jo.xm11_3Panding_1==null?weixuanzhong:jo.xm11_3Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm11_3Panding_2_0",jo.xm11_3Panding_2==null?"/":jo.xm11_3Panding_2},
                        {"xm11_3Panding_3_0",jo.xm11_3Panding_3==null?"/":jo.xm11_3Panding_3},

                        {"xm12_1Panding_1_1",jo.xm12_1Panding_1==null?weixuanzhong:jo.xm12_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm12_1Panding_1_2",jo.xm12_1Panding_1==null?weixuanzhong:jo.xm12_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm12_1Panding_1_3",jo.xm12_1Panding_1==null?weixuanzhong:jo.xm12_1Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm12_1Panding_2_0",jo.xm12_1Panding_2==null?"/":jo.xm12_1Panding_2},
                        {"xm12_1Panding_3_0",jo.xm12_1Panding_3==null?"/":jo.xm12_1Panding_3},
                        {"xm12_1Panding_4_0",jo.xm12_1Panding_4==null?"/":jo.xm12_1Panding_4},

                        {"xm12_2_1Panding_1_1",jo.xm12_2_1Panding_1==null?weixuanzhong:jo.xm12_2_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm12_2_1Panding_1_2",jo.xm12_2_1Panding_1==null?weixuanzhong:jo.xm12_2_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm12_2_1Panding_1_3",jo.xm12_2_1Panding_1==null?weixuanzhong:jo.xm12_2_1Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm12_2_1Panding_2_0",jo.xm12_2_1Panding_2==null?"/":jo.xm12_2_1Panding_2},

                        {"xm12_2_2Panding_1_1",jo.xm12_2_2Panding_1==null?weixuanzhong:jo.xm12_2_2Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_1_2",jo.xm12_2_2Panding_1==null?weixuanzhong:jo.xm12_2_2Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_1_3",jo.xm12_2_2Panding_1==null?weixuanzhong:jo.xm12_2_2Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_2_1",jo.xm12_2_2Panding_2==null?weixuanzhong:jo.xm12_2_2Panding_2=="是"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_2_2",jo.xm12_2_2Panding_2==null?weixuanzhong:jo.xm12_2_2Panding_2=="否"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_2_3",jo.xm12_2_2Panding_2==null?weixuanzhong:jo.xm12_2_2Panding_2=="欠"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_3_1",jo.xm12_2_2Panding_3==null?weixuanzhong:jo.xm12_2_2Panding_3=="是"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_3_2",jo.xm12_2_2Panding_3==null?weixuanzhong:jo.xm12_2_2Panding_3=="否"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_3_3",jo.xm12_2_2Panding_3==null?weixuanzhong:jo.xm12_2_2Panding_3=="欠"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_4_0",jo.xm12_2_2Panding_4==null?"/":jo.xm12_2_2Panding_4},

                        {"xm12_3Panding_1_1",jo.xm12_3Panding_1==null?weixuanzhong:jo.xm12_3Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm12_3Panding_1_2",jo.xm12_3Panding_1==null?weixuanzhong:jo.xm12_3Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm12_3Panding_1_3",jo.xm12_3Panding_1==null?weixuanzhong:jo.xm12_3Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm12_3Panding_2_0",jo.xm12_3Panding_2==null?"/":jo.xm12_3Panding_2},
                        {"xm12_3Panding_3_0",jo.xm12_3Panding_3==null?"/":jo.xm12_3Panding_3},

                        {"xm13_1Panding_1_1",jo.xm13_1Panding_1==null?weixuanzhong:jo.xm13_1Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm13_1Panding_1_2",jo.xm13_1Panding_1==null?weixuanzhong:jo.xm13_1Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm13_1Panding_2_0",jo.xm13_1Panding_2==null?"/":jo.xm13_1Panding_2},

                        {"xm13_2Panding_1_1",jo.xm13_2Panding_1==null?weixuanzhong:jo.xm13_2Panding_1=="是"?xuanzhong:weixuanzhong},
                        {"xm13_2Panding_1_2",jo.xm13_2Panding_1==null?weixuanzhong:jo.xm13_2Panding_1=="否"?xuanzhong:weixuanzhong},
                        {"xm13_2Panding_1_3",jo.xm13_2Panding_1==null?weixuanzhong:jo.xm13_2Panding_1=="欠"?xuanzhong:weixuanzhong},
                        {"xm13_2Panding_2_0",jo.xm13_2Panding_2==null?"/":jo.xm13_2Panding_2},
                        {"xm13_2Panding_3_0",jo.xm13_2Panding_3==null?"/":jo.xm13_2Panding_3},


                        {"xm13_3Panding_1_1",jo.xm13_3Panding_1==null?weixuanzhong:jo.xm13_3Panding_1.IndexOf("01")!=-1?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_1_2",jo.xm13_3Panding_1==null?weixuanzhong:jo.xm13_3Panding_1.IndexOf("02")!=-1?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_1_3",jo.xm13_3Panding_1==null?weixuanzhong:jo.xm13_3Panding_1.IndexOf("03")!=-1?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_1_4",jo.xm13_3Panding_1==null?weixuanzhong:jo.xm13_3Panding_1.IndexOf("04")!=-1?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_1_5",jo.xm13_3Panding_1==null?weixuanzhong:jo.xm13_3Panding_1.IndexOf("05")!=-1?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_1_6",jo.xm13_3Panding_1==null?weixuanzhong:jo.xm13_3Panding_1.IndexOf("06")!=-1?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_2_0",jo.xm13_3Panding_2==null?"/":jo.xm13_3Panding_2},


                        { "xm2_1Panding_0_1", jo.xm2_1Panding ==null?weixuanzhong:jo.xm2_1Panding == "符合" ? xuanzhong : weixuanzhong },
                        { "xm2_1Panding_0_2", jo.xm2_1Panding ==null?weixuanzhong:jo.xm2_1Panding == "不符" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_0_1", jo.xm2_2Panding ==null?weixuanzhong:jo.xm2_2Panding == "符合" ? xuanzhong : weixuanzhong },
                        { "xm2_2Panding_0_2", jo.xm2_2Panding ==null?weixuanzhong:jo.xm2_2Panding == "不符" ? xuanzhong : weixuanzhong },

                        {"xm3_1_1Panding_0_1",jo.xm3_1_1Panding==null?weixuanzhong:jo.xm3_1_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_0_2",jo.xm3_1_1Panding==null?weixuanzhong:jo.xm3_1_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm3_1_1Panding_0_3",jo.xm3_1_1Panding==null?weixuanzhong:jo.xm3_1_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm3_1_2Panding_0_1",jo.xm3_1_2Panding==null?weixuanzhong:jo.xm3_1_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_0_2",jo.xm3_1_2Panding==null?weixuanzhong:jo.xm3_1_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm3_1_2Panding_0_3",jo.xm3_1_2Panding==null?weixuanzhong:jo.xm3_1_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm3_2_1Panding_0_1",jo.xm3_2_1Panding==null?weixuanzhong:jo.xm3_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_0_2",jo.xm3_2_1Panding==null?weixuanzhong:jo.xm3_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm3_2_1Panding_0_3",jo.xm3_2_1Panding==null?weixuanzhong:jo.xm3_2_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm3_2_2Panding_0_1",jo.xm3_2_2Panding==null?weixuanzhong:jo.xm3_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_0_2",jo.xm3_2_2Panding==null?weixuanzhong:jo.xm3_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm3_2_2Panding_0_3",jo.xm3_2_2Panding==null?weixuanzhong:jo.xm3_2_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm3_2_3Panding_0_1",jo.xm3_2_3Panding==null?weixuanzhong:jo.xm3_2_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm3_2_3Panding_0_2",jo.xm3_2_3Panding==null?weixuanzhong:jo.xm3_2_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm3_2_3Panding_0_3",jo.xm3_2_3Panding==null?weixuanzhong:jo.xm3_2_3Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm3_2_4Panding_0_1",jo.xm3_2_4Panding==null?weixuanzhong:jo.xm3_2_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm3_2_4Panding_0_2",jo.xm3_2_4Panding==null?weixuanzhong:jo.xm3_2_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm3_2_4Panding_0_3",jo.xm3_2_4Panding==null?weixuanzhong:jo.xm3_2_4Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm4_1_1Panding_0_1",jo.xm4_1_1Panding==null?weixuanzhong:jo.xm4_1_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm4_1_1Panding_0_2",jo.xm4_1_1Panding==null?weixuanzhong:jo.xm4_1_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm4_1_1Panding_0_3",jo.xm4_1_1Panding==null?weixuanzhong:jo.xm4_1_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm4_1_2Panding_0_1",jo.xm4_1_2Panding==null?weixuanzhong:jo.xm4_1_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm4_1_2Panding_0_2",jo.xm4_1_2Panding==null?weixuanzhong:jo.xm4_1_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm4_1_2Panding_0_3",jo.xm4_1_2Panding==null?weixuanzhong:jo.xm4_1_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm4_2_1Panding_0_1",jo.xm4_2_1Panding==null?weixuanzhong:jo.xm4_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm4_2_1Panding_0_2",jo.xm4_2_1Panding==null?weixuanzhong:jo.xm4_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm4_2_1Panding_0_3",jo.xm4_2_1Panding==null?weixuanzhong:jo.xm4_2_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm4_2_2Panding_0_1",jo.xm4_2_2Panding==null?weixuanzhong:jo.xm4_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm4_2_2Panding_0_2",jo.xm4_2_2Panding==null?weixuanzhong:jo.xm4_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm4_2_2Panding_0_3",jo.xm4_2_2Panding==null?weixuanzhong:jo.xm4_2_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm4_3Panding_0_1",jo.xm4_3Panding==null?weixuanzhong:jo.xm4_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm4_3Panding_0_2",jo.xm4_3Panding==null?weixuanzhong:jo.xm4_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm4_3Panding_0_3",jo.xm4_3Panding==null?weixuanzhong:jo.xm4_3Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_1_1Panding_0_1",jo.xm5_1_1Panding==null?weixuanzhong:jo.xm5_1_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_1_1Panding_0_2",jo.xm5_1_1Panding==null?weixuanzhong:jo.xm5_1_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_1_1Panding_0_3",jo.xm5_1_1Panding==null?weixuanzhong:jo.xm5_1_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_1_2Panding_0_1",jo.xm5_1_2Panding==null?weixuanzhong:jo.xm5_1_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_1_2Panding_0_2",jo.xm5_1_2Panding==null?weixuanzhong:jo.xm5_1_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_1_2Panding_0_3",jo.xm5_1_2Panding==null?weixuanzhong:jo.xm5_1_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_2_1Panding_0_1",jo.xm5_2_1Panding==null?weixuanzhong:jo.xm5_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_2_1Panding_0_2",jo.xm5_2_1Panding==null?weixuanzhong:jo.xm5_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_2_1Panding_0_3",jo.xm5_2_1Panding==null?weixuanzhong:jo.xm5_2_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_2_2Panding_0_1",jo.xm5_2_2Panding==null?weixuanzhong:jo.xm5_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_2_2Panding_0_2",jo.xm5_2_2Panding==null?weixuanzhong:jo.xm5_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_2_2Panding_0_3",jo.xm5_2_2Panding==null?weixuanzhong:jo.xm5_2_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_3_1Panding_0_1",jo.xm5_3_1Panding==null?weixuanzhong:jo.xm5_3_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_3_1Panding_0_2",jo.xm5_3_1Panding==null?weixuanzhong:jo.xm5_3_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_3_1Panding_0_3",jo.xm5_3_1Panding==null?weixuanzhong:jo.xm5_3_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_3_2Panding_0_1",jo.xm5_3_2Panding==null?weixuanzhong:jo.xm5_3_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_3_2Panding_0_2",jo.xm5_3_2Panding==null?weixuanzhong:jo.xm5_3_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_3_2Panding_0_3",jo.xm5_3_2Panding==null?weixuanzhong:jo.xm5_3_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_4_1Panding_0_1",jo.xm5_4_1Panding==null?weixuanzhong:jo.xm5_4_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_4_1Panding_0_2",jo.xm5_4_1Panding==null?weixuanzhong:jo.xm5_4_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_4_1Panding_0_3",jo.xm5_4_1Panding==null?weixuanzhong:jo.xm5_4_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_4_2Panding_0_1",jo.xm5_4_2Panding==null?weixuanzhong:jo.xm5_4_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_4_2Panding_0_2",jo.xm5_4_2Panding==null?weixuanzhong:jo.xm5_4_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_4_2Panding_0_3",jo.xm5_4_2Panding==null?weixuanzhong:jo.xm5_4_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm5_5Panding_0_1",jo.xm5_5Panding==null?weixuanzhong:jo.xm5_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm5_5Panding_0_2",jo.xm5_5Panding==null?weixuanzhong:jo.xm5_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm5_5Panding_0_3",jo.xm5_5Panding==null?weixuanzhong:jo.xm5_5Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm6_1_1Panding_0_1",jo.xm6_1_1Panding==null?weixuanzhong:jo.xm6_1_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm6_1_1Panding_0_2",jo.xm6_1_1Panding==null?weixuanzhong:jo.xm6_1_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm6_1_1Panding_0_3",jo.xm6_1_1Panding==null?weixuanzhong:jo.xm6_1_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm6_1_2Panding_0_1",jo.xm6_1_2Panding==null?weixuanzhong:jo.xm6_1_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm6_1_2Panding_0_2",jo.xm6_1_2Panding==null?weixuanzhong:jo.xm6_1_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm6_1_2Panding_0_3",jo.xm6_1_2Panding==null?weixuanzhong:jo.xm6_1_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm6_1_3Panding_0_1",jo.xm6_1_3Panding==null?weixuanzhong:jo.xm6_1_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm6_1_3Panding_0_2",jo.xm6_1_3Panding==null?weixuanzhong:jo.xm6_1_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm6_1_3Panding_0_3",jo.xm6_1_3Panding==null?weixuanzhong:jo.xm6_1_3Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm6_1_4Panding_0_1",jo.xm6_1_4Panding==null?weixuanzhong:jo.xm6_1_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm6_1_4Panding_0_2",jo.xm6_1_4Panding==null?weixuanzhong:jo.xm6_1_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm6_1_4Panding_0_3",jo.xm6_1_4Panding==null?weixuanzhong:jo.xm6_1_4Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm6_2_1Panding_0_1",jo.xm6_2_1Panding==null?weixuanzhong:jo.xm6_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm6_2_1Panding_0_2",jo.xm6_2_1Panding==null?weixuanzhong:jo.xm6_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm6_2_1Panding_0_3",jo.xm6_2_1Panding==null?weixuanzhong:jo.xm6_2_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm6_2_2Panding_0_1",jo.xm6_2_2Panding==null?weixuanzhong:jo.xm6_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm6_2_2Panding_0_2",jo.xm6_2_2Panding==null?weixuanzhong:jo.xm6_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm6_2_2Panding_0_3",jo.xm6_2_2Panding==null?weixuanzhong:jo.xm6_2_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm7_1_1Panding_0_1",jo.xm7_1_1Panding==null?weixuanzhong:jo.xm7_1_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_1_1Panding_0_2",jo.xm7_1_1Panding==null?weixuanzhong:jo.xm7_1_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_1_1Panding_0_3",jo.xm7_1_1Panding==null?weixuanzhong:jo.xm7_1_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm7_1_2Panding_0_1",jo.xm7_1_2Panding==null?weixuanzhong:jo.xm7_1_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_1_2Panding_0_2",jo.xm7_1_2Panding==null?weixuanzhong:jo.xm7_1_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_1_2Panding_0_3",jo.xm7_1_2Panding==null?weixuanzhong:jo.xm7_1_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm7_1_3Panding_0_1",jo.xm7_1_3Panding==null?weixuanzhong:jo.xm7_1_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_1_3Panding_0_2",jo.xm7_1_3Panding==null?weixuanzhong:jo.xm7_1_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_1_3Panding_0_3",jo.xm7_1_3Panding==null?weixuanzhong:jo.xm7_1_3Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm7_1_4Panding_0_1",jo.xm7_1_4Panding==null?weixuanzhong:jo.xm7_1_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_1_4Panding_0_2",jo.xm7_1_4Panding==null?weixuanzhong:jo.xm7_1_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_1_4Panding_0_3",jo.xm7_1_4Panding==null?weixuanzhong:jo.xm7_1_4Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm7_1_5Panding_0_1",jo.xm7_1_5Panding==null?weixuanzhong:jo.xm7_1_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_1_5Panding_0_2",jo.xm7_1_5Panding==null?weixuanzhong:jo.xm7_1_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_1_5Panding_0_3",jo.xm7_1_5Panding==null?weixuanzhong:jo.xm7_1_5Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm7_1_6Panding_0_1",jo.xm7_1_6Panding==null?weixuanzhong:jo.xm7_1_6Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_1_6Panding_0_2",jo.xm7_1_6Panding==null?weixuanzhong:jo.xm7_1_6Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_1_6Panding_0_3",jo.xm7_1_6Panding==null?weixuanzhong:jo.xm7_1_6Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_1_6Panding_0_4",jo.xm7_1_6Panding==null?weixuanzhong:jo.xm7_1_6Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_1Panding_0_1",jo.xm7_2_1Panding==null?weixuanzhong:jo.xm7_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_1Panding_0_2",jo.xm7_2_1Panding==null?weixuanzhong:jo.xm7_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_1Panding_0_3",jo.xm7_2_1Panding==null?weixuanzhong:jo.xm7_2_1Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_2_1Panding_0_4",jo.xm7_2_1Panding==null?weixuanzhong:jo.xm7_2_1Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_2Panding_0_1",jo.xm7_2_2Panding==null?weixuanzhong:jo.xm7_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_2Panding_0_2",jo.xm7_2_2Panding==null?weixuanzhong:jo.xm7_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_2Panding_0_3",jo.xm7_2_2Panding==null?weixuanzhong:jo.xm7_2_2Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_2_2Panding_0_4",jo.xm7_2_2Panding==null?weixuanzhong:jo.xm7_2_2Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_3Panding_0_1",jo.xm7_2_3Panding==null?weixuanzhong:jo.xm7_2_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_3Panding_0_2",jo.xm7_2_3Panding==null?weixuanzhong:jo.xm7_2_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_3Panding_0_3",jo.xm7_2_3Panding==null?weixuanzhong:jo.xm7_2_3Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_2_3Panding_0_4",jo.xm7_2_3Panding==null?weixuanzhong:jo.xm7_2_3Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_4Panding_0_1",jo.xm7_2_4Panding==null?weixuanzhong:jo.xm7_2_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_4Panding_0_2",jo.xm7_2_4Panding==null?weixuanzhong:jo.xm7_2_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_4Panding_0_3",jo.xm7_2_4Panding==null?weixuanzhong:jo.xm7_2_4Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_2_4Panding_0_4",jo.xm7_2_4Panding==null?weixuanzhong:jo.xm7_2_4Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_5Panding_0_1",jo.xm7_2_5Panding==null?weixuanzhong:jo.xm7_2_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_5Panding_0_2",jo.xm7_2_5Panding==null?weixuanzhong:jo.xm7_2_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_5Panding_0_3",jo.xm7_2_5Panding==null?weixuanzhong:jo.xm7_2_5Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_2_5Panding_0_4",jo.xm7_2_5Panding==null?weixuanzhong:jo.xm7_2_5Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_6Panding_0_1",jo.xm7_2_6Panding==null?weixuanzhong:jo.xm7_2_6Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_6Panding_0_2",jo.xm7_2_6Panding==null?weixuanzhong:jo.xm7_2_6Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_6Panding_0_3",jo.xm7_2_6Panding==null?weixuanzhong:jo.xm7_2_6Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm7_2_6Panding_0_4",jo.xm7_2_6Panding==null?weixuanzhong:jo.xm7_2_6Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm7_2_7Panding_0_1",jo.xm7_2_7Panding==null?weixuanzhong:jo.xm7_2_7Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm7_2_7Panding_0_2",jo.xm7_2_7Panding==null?weixuanzhong:jo.xm7_2_7Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm7_2_7Panding_0_3",jo.xm7_2_7Panding==null?weixuanzhong:jo.xm7_2_7Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm8_1_1Panding_0_1",jo.xm8_1_1Panding==null?weixuanzhong:jo.xm8_1_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_1_1Panding_0_2",jo.xm8_1_1Panding==null?weixuanzhong:jo.xm8_1_1Panding=="不符"?xuanzhong:weixuanzhong},


                        {"xm8_1_2Panding_0_1",jo.xm8_1_2Panding==null?weixuanzhong:jo.xm8_1_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_1_2Panding_0_2",jo.xm8_1_2Panding==null?weixuanzhong:jo.xm8_1_2Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm8_1_2Panding_0_3",jo.xm8_1_2Panding==null?weixuanzhong:jo.xm8_1_2Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm8_1_3Panding_0_1",jo.xm8_1_3Panding==null?weixuanzhong:jo.xm8_1_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_1_3Panding_0_2",jo.xm8_1_3Panding==null?weixuanzhong:jo.xm8_1_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_1_3Panding_0_3",jo.xm8_1_3Panding==null?weixuanzhong:jo.xm8_1_3Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm8_1_3Panding_0_4",jo.xm8_1_3Panding==null?weixuanzhong:jo.xm8_1_3Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm8_2_1Panding_0_1",jo.xm8_2_1Panding==null?weixuanzhong:jo.xm8_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_2_1Panding_0_2",jo.xm8_2_1Panding==null?weixuanzhong:jo.xm8_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_2_1Panding_0_3",jo.xm8_2_1Panding==null?weixuanzhong:jo.xm8_2_1Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm8_2_1Panding_0_4",jo.xm8_2_1Panding==null?weixuanzhong:jo.xm8_2_1Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm8_2_2Panding_0_1",jo.xm8_2_2Panding==null?weixuanzhong:jo.xm8_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_2_2Panding_0_2",jo.xm8_2_2Panding==null?weixuanzhong:jo.xm8_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_2_2Panding_0_3",jo.xm8_2_2Panding==null?weixuanzhong:jo.xm8_2_2Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm8_2_2Panding_0_4",jo.xm8_2_2Panding==null?weixuanzhong:jo.xm8_2_2Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm8_2_3Panding_0_1",jo.xm8_2_3Panding==null?weixuanzhong:jo.xm8_2_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_2_3Panding_0_2",jo.xm8_2_3Panding==null?weixuanzhong:jo.xm8_2_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_2_3Panding_0_3",jo.xm8_2_3Panding==null?weixuanzhong:jo.xm8_2_3Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm8_2_3Panding_0_4",jo.xm8_2_3Panding==null?weixuanzhong:jo.xm8_2_3Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm8_2_4Panding_0_1",jo.xm8_2_4Panding==null?weixuanzhong:jo.xm8_2_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_2_4Panding_0_2",jo.xm8_2_4Panding==null?weixuanzhong:jo.xm8_2_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_2_4Panding_0_3",jo.xm8_2_4Panding==null?weixuanzhong:jo.xm8_2_4Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm8_2_5Panding_0_1",jo.xm8_2_5Panding==null?weixuanzhong:jo.xm8_2_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_2_5Panding_0_2",jo.xm8_2_5Panding==null?weixuanzhong:jo.xm8_2_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_2_5Panding_0_3",jo.xm8_2_5Panding==null?weixuanzhong:jo.xm8_2_5Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm8_2_6Panding_0_1",jo.xm8_2_6Panding==null?weixuanzhong:jo.xm8_2_6Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm8_2_6Panding_0_2",jo.xm8_2_6Panding==null?weixuanzhong:jo.xm8_2_6Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm8_2_6Panding_0_3",jo.xm8_2_6Panding==null?weixuanzhong:jo.xm8_2_6Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm8_2_6Panding_0_4",jo.xm8_2_6Panding==null?weixuanzhong:jo.xm8_2_6Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_1Panding_0_1",jo.xm9_1Panding==null?weixuanzhong:jo.xm9_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_1Panding_0_2",jo.xm9_1Panding==null?weixuanzhong:jo.xm9_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_1Panding_0_3",jo.xm9_1Panding==null?weixuanzhong:jo.xm9_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_2_1Panding_0_1",jo.xm9_2_1Panding==null?weixuanzhong:jo.xm9_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_2_1Panding_0_2",jo.xm9_2_1Panding==null?weixuanzhong:jo.xm9_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_2_1Panding_0_3",jo.xm9_2_1Panding==null?weixuanzhong:jo.xm9_2_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_2_2Panding_0_1",jo.xm9_2_2Panding==null?weixuanzhong:jo.xm9_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_2_2Panding_0_2",jo.xm9_2_2Panding==null?weixuanzhong:jo.xm9_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_2_2Panding_0_3",jo.xm9_2_2Panding==null?weixuanzhong:jo.xm9_2_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_3_1Panding_0_1",jo.xm9_3_1Panding==null?weixuanzhong:jo.xm9_3_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_3_1Panding_0_2",jo.xm9_3_1Panding==null?weixuanzhong:jo.xm9_3_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_3_1Panding_0_3",jo.xm9_3_1Panding==null?weixuanzhong:jo.xm9_3_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_3_2Panding_0_1",jo.xm9_3_2Panding==null?weixuanzhong:jo.xm9_3_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_3_2Panding_0_2",jo.xm9_3_2Panding==null?weixuanzhong:jo.xm9_3_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_3_2Panding_0_3",jo.xm9_3_2Panding==null?weixuanzhong:jo.xm9_3_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_4_1Panding_0_1",jo.xm9_4_1Panding==null?weixuanzhong:jo.xm9_4_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_4_1Panding_0_2",jo.xm9_4_1Panding==null?weixuanzhong:jo.xm9_4_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_4_1Panding_0_3",jo.xm9_4_1Panding==null?weixuanzhong:jo.xm9_4_1Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm9_4_1Panding_0_4",jo.xm9_4_1Panding==null?weixuanzhong:jo.xm9_4_1Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_4_2Panding_0_1",jo.xm9_4_2Panding==null?weixuanzhong:jo.xm9_4_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_4_2Panding_0_2",jo.xm9_4_2Panding==null?weixuanzhong:jo.xm9_4_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_4_2Panding_0_3",jo.xm9_4_2Panding==null?weixuanzhong:jo.xm9_4_2Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm9_4_2Panding_0_4",jo.xm9_4_2Panding==null?weixuanzhong:jo.xm9_4_2Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_4_3Panding_0_1",jo.xm9_4_3Panding==null?weixuanzhong:jo.xm9_4_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_4_3Panding_0_2",jo.xm9_4_3Panding==null?weixuanzhong:jo.xm9_4_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_4_3Panding_0_3",jo.xm9_4_3Panding==null?weixuanzhong:jo.xm9_4_3Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm9_4_3Panding_0_4",jo.xm9_4_3Panding==null?weixuanzhong:jo.xm9_4_3Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_4_4Panding_0_1",jo.xm9_4_4Panding==null?weixuanzhong:jo.xm9_4_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_4_4Panding_0_2",jo.xm9_4_4Panding==null?weixuanzhong:jo.xm9_4_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_4_4Panding_0_3",jo.xm9_4_4Panding==null?weixuanzhong:jo.xm9_4_4Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_5Panding_0_1",jo.xm9_5Panding==null?weixuanzhong:jo.xm9_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_5Panding_0_2",jo.xm9_5Panding==null?weixuanzhong:jo.xm9_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_5Panding_0_3",jo.xm9_5Panding==null?weixuanzhong:jo.xm9_5Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_6_1Panding_0_1",jo.xm9_6_1Panding==null?weixuanzhong:jo.xm9_6_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_6_1Panding_0_2",jo.xm9_6_1Panding==null?weixuanzhong:jo.xm9_6_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_6_1Panding_0_3",jo.xm9_6_1Panding==null?weixuanzhong:jo.xm9_6_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_6_2Panding_0_1",jo.xm9_6_2Panding==null?weixuanzhong:jo.xm9_6_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_6_2Panding_0_2",jo.xm9_6_2Panding==null?weixuanzhong:jo.xm9_6_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_6_2Panding_0_3",jo.xm9_6_2Panding==null?weixuanzhong:jo.xm9_6_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_6_2Panding_0_4",jo.xm9_6_2Panding==null?weixuanzhong:jo.xm9_6_2Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_6_3Panding_0_1",jo.xm9_6_3Panding==null?weixuanzhong:jo.xm9_6_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_6_3Panding_0_2",jo.xm9_6_3Panding==null?weixuanzhong:jo.xm9_6_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_6_3Panding_0_3",jo.xm9_6_3Panding==null?weixuanzhong:jo.xm9_6_3Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm9_6_3Panding_0_4",jo.xm9_6_3Panding==null?weixuanzhong:jo.xm9_6_3Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_6_4Panding_0_1",jo.xm9_6_4Panding==null?weixuanzhong:jo.xm9_6_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_6_4Panding_0_2",jo.xm9_6_4Panding==null?weixuanzhong:jo.xm9_6_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_6_4Panding_0_3",jo.xm9_6_4Panding==null?weixuanzhong:jo.xm9_6_4Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm9_6_4Panding_0_4",jo.xm9_6_4Panding==null?weixuanzhong:jo.xm9_6_4Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm9_6_5Panding_0_1",jo.xm9_6_5Panding==null?weixuanzhong:jo.xm9_6_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_6_5Panding_0_2",jo.xm9_6_5Panding==null?weixuanzhong:jo.xm9_6_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_6_5Panding_0_3",jo.xm9_6_5Panding==null?weixuanzhong:jo.xm9_6_5Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_7_1Panding_0_1",jo.xm9_7_1Panding==null?weixuanzhong:jo.xm9_7_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_7_1Panding_0_2",jo.xm9_7_1Panding==null?weixuanzhong:jo.xm9_7_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_7_2Panding_0_1",jo.xm9_7_2Panding==null?weixuanzhong:jo.xm9_7_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_7_2Panding_0_2",jo.xm9_7_2Panding==null?weixuanzhong:jo.xm9_7_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_7_2Panding_0_3",jo.xm9_7_2Panding==null?weixuanzhong:jo.xm9_7_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm9_8Panding_0_1",jo.xm9_8Panding==null?weixuanzhong:jo.xm9_8Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm9_8Panding_0_2",jo.xm9_8Panding==null?weixuanzhong:jo.xm9_8Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm9_8Panding_0_3",jo.xm9_8Panding==null?weixuanzhong:jo.xm9_8Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm9_8Panding_0_4",jo.xm9_8Panding==null?weixuanzhong:jo.xm9_8Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm10_1Panding_0_1",jo.xm10_1Panding==null?weixuanzhong:jo.xm10_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_0_2",jo.xm10_1Panding==null?weixuanzhong:jo.xm10_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm10_1Panding_0_3",jo.xm10_1Panding==null?weixuanzhong:jo.xm10_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm10_2Panding_0_1",jo.xm10_2Panding==null?weixuanzhong:jo.xm10_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm10_2Panding_0_2",jo.xm10_2Panding==null?weixuanzhong:jo.xm10_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm10_2Panding_0_3",jo.xm10_2Panding==null?weixuanzhong:jo.xm10_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm10_3Panding_0_1",jo.xm10_3Panding==null?weixuanzhong:jo.xm10_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm10_3Panding_0_2",jo.xm10_3Panding==null?weixuanzhong:jo.xm10_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm10_3Panding_0_3",jo.xm10_3Panding==null?weixuanzhong:jo.xm10_3Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm10_4Panding_0_1",jo.xm10_4Panding==null?weixuanzhong:jo.xm10_4Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm10_4Panding_0_2",jo.xm10_4Panding==null?weixuanzhong:jo.xm10_4Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm10_4Panding_0_3",jo.xm10_4Panding==null?weixuanzhong:jo.xm10_4Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm10_5Panding_0_1",jo.xm10_5Panding==null?weixuanzhong:jo.xm10_5Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_0_2",jo.xm10_5Panding==null?weixuanzhong:jo.xm10_5Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_0_3",jo.xm10_5Panding==null?weixuanzhong:jo.xm10_5Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm10_5Panding_0_4",jo.xm10_5Panding==null?weixuanzhong:jo.xm10_5Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm11_1Panding_0_1",jo.xm11_1Panding==null?weixuanzhong:jo.xm11_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm11_1Panding_0_2",jo.xm11_1Panding==null?weixuanzhong:jo.xm11_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm11_1Panding_0_3",jo.xm11_1Panding==null?weixuanzhong:jo.xm11_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm11_2Panding_0_1",jo.xm11_2Panding==null?weixuanzhong:jo.xm11_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm11_2Panding_0_2",jo.xm11_2Panding==null?weixuanzhong:jo.xm11_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm11_3Panding_0_1",jo.xm11_3Panding==null?weixuanzhong:jo.xm11_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm11_3Panding_0_2",jo.xm11_3Panding==null?weixuanzhong:jo.xm11_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm11_3Panding_0_3",jo.xm11_3Panding==null?weixuanzhong:jo.xm11_3Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm12_1Panding_0_1",jo.xm12_1Panding==null?weixuanzhong:jo.xm12_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm12_1Panding_0_2",jo.xm12_1Panding==null?weixuanzhong:jo.xm12_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm12_1Panding_0_3",jo.xm12_1Panding==null?weixuanzhong:jo.xm12_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm12_2_1Panding_0_1",jo.xm12_2_1Panding==null?weixuanzhong:jo.xm12_2_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm12_2_1Panding_0_2",jo.xm12_2_1Panding==null?weixuanzhong:jo.xm12_2_1Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm12_2_1Panding_0_3",jo.xm12_2_1Panding==null?weixuanzhong:jo.xm12_2_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm12_2_2Panding_0_1",jo.xm12_2_2Panding==null?weixuanzhong:jo.xm12_2_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_0_2",jo.xm12_2_2Panding==null?weixuanzhong:jo.xm12_2_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm12_2_2Panding_0_3",jo.xm12_2_2Panding==null?weixuanzhong:jo.xm12_2_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm12_3Panding_0_1",jo.xm12_3Panding==null?weixuanzhong:jo.xm12_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm12_3Panding_0_2",jo.xm12_3Panding==null?weixuanzhong:jo.xm12_3Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm12_3Panding_0_3",jo.xm12_3Panding==null?weixuanzhong:jo.xm12_3Panding=="不符"?xuanzhong:weixuanzhong},
                        {"xm12_3Panding_0_4",jo.xm12_3Panding==null?weixuanzhong:jo.xm12_3Panding=="不适用"?xuanzhong:weixuanzhong},

                        {"xm13_1Panding_0_1",jo.xm13_1Panding==null?weixuanzhong:jo.xm13_1Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm13_1Panding_0_2",jo.xm13_1Panding==null?weixuanzhong:jo.xm13_1Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm13_2Panding_0_1",jo.xm13_2Panding==null?weixuanzhong:jo.xm13_2Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm13_2Panding_0_2",jo.xm13_2Panding==null?weixuanzhong:jo.xm13_2Panding=="基本"?xuanzhong:weixuanzhong},
                        {"xm13_2Panding_0_3",jo.xm13_2Panding==null?weixuanzhong:jo.xm13_2Panding=="不符"?xuanzhong:weixuanzhong},

                        {"xm13_3Panding_0_1",jo.xm13_3Panding==null?weixuanzhong:jo.xm13_3Panding=="符合"?xuanzhong:weixuanzhong},
                        {"xm13_3Panding_0_2",jo.xm13_3Panding==null?weixuanzhong:jo.xm13_3Panding=="不符"?xuanzhong:weixuanzhong},



        };
        #endregion

        BookmarkCollection bookmarks =    doc.Range.Bookmarks;
        Console.WriteLine("1");
        //for (int t = 0; t < siblings.Length / 2; t++)
        //{
        //    Bookmark bookmark = bookmarks[siblings[t, 0]];
        //    bookmark.Text = siblings[t, 1];

        //}
        Console.WriteLine("2");
        for (int t = 0; t < siblings.Length / 2; t++)
        {
            builder.MoveToBookmark(siblings[t, 0], true, false);
            Node _pnode = builder.CurrentNode.NextSibling;
            _pnode.Remove();
            Aspose.Words.Font font = builder.Font;
            //font.Bold = true;
            font.Name = "宋体";
            font.Color = Color.Black;
            builder.Write(siblings[t, 1]);
        }
        // We can use a "FindReplaceOptions" object to modify the find-and-replace process. 
        Aspose.Words.Replacing.FindReplaceOptions options = new Aspose.Words.Replacing.FindReplaceOptions();
        options.ApplyFont.Color = Color.Red;
        doc.Range.Replace(xuanzhong+"不符合", xuanzhong+"不符合", options);
        doc.Range.Replace("否"+xuanzhong, "否"+xuanzhong, options);
        options.ApplyFont.Color = Color.Blue;
        doc.Range.Replace("有欠缺"+xuanzhong, "有欠缺"+xuanzhong, options);
        doc.Range.Replace(xuanzhong+"基本符合", xuanzhong+"基本符合", options);
        options.ApplyFont.Color = Color.Black;
        doc.Range.Replace( weixuanzhong+weixuanzhong, weixuanzhong, options);
        doc.Range.Replace( xuanzhong+xuanzhong, xuanzhong, options);
        doc.Range.Replace( weixuanzhong+xuanzhong, weixuanzhong, options);
        /* Quick typed access to all Table child nodes contained in the Body. */
        /* Quick typed access to the first child Section node of the Document. */
        Section section = doc.FirstSection;
        /* Quick typed access to the Body child node of the Section. */
        Body body = section.Body;
        TableCollection tables = body.Tables;
        Aspose.Words.Tables.Table table = tables[0];
        //for (int i= 0; i< table.Rows.Count;i++)
        //{
        //    Row row = table.Rows[i];
        //    int rowIndex = table.Rows.IndexOf(row);
        //    //builder.Write("Row: " + rowIndex+"\n");
        //    // Iterate through all cells in the row
        //    for (int j =0;j<row.Cells.Count;j++)
        //    {
        //        Cell _cell = row.Cells[j];
        //        int cellIndex = row.Cells.IndexOf(_cell);
        //        // Get the plain text content of this cell.
        //        string cellText = _cell.ToString(SaveFormat.Text).Trim();
        //        // Print the content of the cell.
        //        EditCell(table,doc,i,j, i + "/" +j,false);

        //    }
        //    //Console.WriteLine();
        //    // builder.Write("----------------" + rowIndex + "\n");
        //}
        List<int> _xiangmu = new  List<int>(){ };
        string[] _xm_temp = PS_XiangMu.Split(',');
        for(int t=0;t< _xm_temp.Length;t++)
            _xiangmu.Add(Convert.ToInt16( _xm_temp[t]));
        doc = delteRows(doc,_xiangmu.ToArray(),tempFile);
        string outFileName = saveFilePath +ids+"\\"+ ids+"评审记录";
        string outFileDocx= outFileName+ ".doc";
        string outFilePdf= outFileName+ ".pdf";
        #region 打印模板中的所有书签        

        //Document docs = new Document();
        //DocumentBuilder builders = new DocumentBuilder(docs);
        //builders.Write(json);
        //string dataDir = saveFilePath + Guid.NewGuid().ToString("N") + "Bookmark.Table_out.doc";
        //docs.Save(dataDir);
        //Document docs = new Document();
        //DocumentBuilder builders = new DocumentBuilder(docs);
        //Aspose.Words.Tables.Table table = builders.StartTable();
        //for (int t = 0; t < bookmarks.Count; t++)
        //{
        //    //插入一个单元格
        //    builders.InsertCell();

        //    //调用InsertCell之后在此处开始书签

        //    builders.Write(bookmarks[t].Name);

        //    //插入一个单元格
        //    builders.InsertCell();
        //    builders.Write(bookmarks[t].Text);

        //    builders.EndRow();
        //}

        //builders.EndTable();
        //// 书签结尾

        //string dataDir = saveFilePath + Guid.NewGuid().ToString("N") + "Bookmark.Table_out.doc";
        //docs.Save(dataDir);
        #endregion
        if (File.Exists(outFileDocx))
        {
            File.Delete(outFileDocx);
        }
        if (File.Exists(outFilePdf))
        {
            File.Delete(outFilePdf);
        }
        doc.Save(outFileDocx);    /* 将文件存档 ，在临时文件 */
        doc.Save(outFilePdf);    /* 将文件存档 ，在临时文件 */
        if (ids  != "") {
            string _tempSql = "update AnBiaoPingShen set PS_File ='" + urlconvertor(outFileDocx) + "' where PS_ID='" + ids + "'";
            Class1.ExecSql(_tempSql);
        }
        // strJson();
        return urlconvertor( outFileDocx);
    }
    #region 对Word中某一个表格格式进行修改 
    private static Aspose.Words.Tables.Table EditCell (Aspose.Words.Tables.Table table, Document doc, int row, int cell, string value,bool flag)
    {
        Cell c = table.Rows[row].Cells[cell];
        Paragraph p = new Paragraph(doc);
        DocumentBuilder builder = new DocumentBuilder(doc);   /* 建立DocumentBuilder物件 */
        if (flag)
        {
            if (c.HasChildNodes)
            {
                foreach (Node n in c.ChildNodes)
                {
                    c.RemoveChild(n);
                }
            }
        }

        Run r = new Run(doc, value);
        r.Font.Name = "字体";
        r.Font.Size = 11;//字号
        r.Font.Bold = true;    //加粗                      
        p.ParagraphFormat.Alignment = ParagraphAlignment.Center; //水平居中
        p.AppendChild(r);
        table.Rows[row].Cells[cell].AppendChild(p);
        //builder.InsertCell();
        //builder.Write("Row 2, Col 1");
        //table.Rows[row].Cells.Insert(cell, p);

        return table;
    }

    #endregion
    public string dateFormat(string _time)
    {
        if (_time.IndexOf("G") == -1)
        {
            return "";
        }
        else
        {
            string s1 = _time.Replace("GMT+0800 (中国标准时间)", "");
            string stringValue = Convert.ToDateTime(s1).ToString("yyyy年MM月dd日");
            return stringValue;
        }
    }


    public class Student
    {

        public string xm_BianHao { get; set; }
        public string xm_ChangJia { get; set; }
        public string xm_PingShenZhu { get; set; }
        public string xm_StartTime { get; set; }
        public string xm_EndTime { get; set; }

        public string    xm_2JieDai    { get; set; }
        public string    xm_3JieDai    { get; set; }
        public string    xm_4JieDai    { get; set; }
        public string    xm_5JieDai    { get; set; }
        public string    xm_6JieDai    { get; set; }
        public string    xm_7JieDai    { get; set; }
        public string    xm_8JieDai    { get; set; }
        public string    xm_9JieDai    { get; set; }
        public string    xm_10JieDai    { get; set; }
        public string    xm_11JieDai    { get; set; }
        public string    xm_12JieDai    { get; set; }
        public string    xm_13JieDai    { get; set; }

        public string xm2_1Panding { get; set; }
        public string xm2_1Panding_1 { get; set; }
        public string xm2_1Panding_2 { get; set; }
        public string xm2_1Panding_3 { get; set; }
        public string xm2_1Panding_4 { get; set; }
        public string xm2_2Panding { get; set; }
        public string xm2_2Panding_1 { get; set; }
        public string xm2_2Panding_2 { get; set; }
        public string xm2_2Panding_3 { get; set; }
        public string xm2_2Panding_4 { get; set; }
        public string xm2_2Panding_5 { get; set; }
        public string xm2_2Panding_6 { get; set; }
        public string xm3_1_1Panding_1 { get; set; }
        public string xm3_1_1Panding_2 { get; set; }
        public string xm3_1_1Panding_3 { get; set; }
        public string xm3_1_2Panding_1 { get; set; }
        public string xm3_1_2Panding_2 { get; set; }
        public string xm3_1_2Panding_3 { get; set; }
        public string xm3_1_2Panding_4 { get; set; }
        public string xm3_2_1Panding_1 { get; set; }
        public string xm3_2_1Panding_2 { get; set; }
        public string xm3_2_1Panding_3 { get; set; }
        public string xm3_2_1Panding_4 { get; set; }
        public string xm3_2_1Panding_5 { get; set; }
        public string xm3_2_1Panding_6 { get; set; }
        public string xm3_2_1Panding_7 { get; set; }
        public string xm3_2_1Panding_8 { get; set; }
        public string xm3_2_1Panding_9 { get; set; }
        public string xm3_2_2Panding_1 { get; set; }
        public string xm3_2_2Panding_2 { get; set; }
        public string xm3_2_2Panding_3 { get; set; }
        public string xm3_2_2Panding_4 { get; set; }
        public string xm3_2_2Panding_5 { get; set; }
        public string xm3_2_2Panding_6 { get; set; }
        public string xm3_2_3Panding_1 { get; set; }
        public string xm3_2_3Panding_2 { get; set; }
        public string xm3_2_3Panding_3 { get; set; }
        public string xm3_2_4Panding_1 { get; set; }
        public string xm3_2_4Panding_2 { get; set; }
        public string xm4_1_1Panding_1 { get; set; }
        public string xm4_1_1Panding_2 { get; set; }
        public string xm4_1_1Panding_3 { get; set; }
        public string xm4_1_1Panding_4 { get; set; }
        public string xm4_1_1Panding_5 { get; set; }
        public string xm4_1_1Panding_6 { get; set; }
        public string xm4_1_1Panding_7 { get; set; }
        public string xm4_1_1Panding_8 { get; set; }
        public string xm4_1_2Panding_1 { get; set; }
        public string xm4_1_2Panding_2 { get; set; }
        public string xm4_2_1Panding_1 { get; set; }
        public string xm4_2_1Panding_2 { get; set; }
        public string xm4_2_1Panding_3 { get; set; }
        public string xm4_2_1Panding_4 { get; set; }
        public string xm4_2_1Panding_5 { get; set; }
        public string xm4_2_1Panding_6 { get; set; }
        public string xm4_2_1Panding_7 { get; set; }
        public string xm4_2_1Panding_8 { get; set; }
        public string xm4_2_2Panding_1 { get; set; }
        public string xm4_2_2Panding_2 { get; set; }
        public string xm4_3Panding_1 { get; set; }
        public string xm4_3Panding_2 { get; set; }
        public string xm4_3Panding_3 { get; set; }
        public string xm4_3Panding_4 { get; set; }
        public string xm4_3Panding_5 { get; set; }
        public string xm4_3Panding_6 { get; set; }
        public string xm4_3Panding_7 { get; set; }
        public string xm4_3Panding_8 { get; set; }
        public string xm4_3Panding_9 { get; set; }
        public string xm4_3Panding_10 { get; set; }
        public string xm4_3Panding_11 { get; set; }
        public string xm4_3Panding_12 { get; set; }
        public string xm5_1_1Panding_1 { get; set; }
        public string xm5_1_1Panding_2 { get; set; }
        public string xm5_1_1Panding_3 { get; set; }
        public string xm5_1_1Panding_4 { get; set; }
        public string xm5_1_2Panding_1 { get; set; }
        public string xm5_1_2Panding_2 { get; set; }
        public string xm5_1_2Panding_3 { get; set; }
        public string xm5_1_2Panding_4 { get; set; }
        public string xm5_1_2Panding_5 { get; set; }
        public string xm5_1_2Panding_6 { get; set; }
        public string xm5_1_2Panding_7 { get; set; }
        public string xm5_1_2Panding_8 { get; set; }
        public string xm5_2_1Panding_1 { get; set; }
        public string xm5_2_1Panding_2 { get; set; }
        public string xm5_2_1Panding_3 { get; set; }
        public string xm5_2_1Panding_4 { get; set; }
        public string xm5_2_1Panding_5 { get; set; }
        public string xm5_2_1Panding_6 { get; set; }
        public string xm5_2_1Panding_7 { get; set; }
        public string xm5_2_1Panding_8 { get; set; }
        public string xm5_2_1Panding_9 { get; set; }
        public string xm5_2_1Panding_10 { get; set; }
        public string xm5_2_1Panding_11 { get; set; }
        public string xm5_2_1Panding_12 { get; set; }
        public string xm5_2_1Panding_13 { get; set; }
        public string xm5_2_1Panding_14 { get; set; }
        public string xm5_2_1Panding_15 { get; set; }
        public string xm5_2_1Panding_16 { get; set; }
        public string xm5_2_1Panding_17 { get; set; }
        public string xm5_2_1Panding_18 { get; set; }
        public string xm5_2_1Panding_19 { get; set; }
        public string xm5_2_1Panding_20 { get; set; }
        public string xm5_2_2Panding_1 { get; set; }
        public string xm5_2_2Panding_2 { get; set; }
        public string xm5_2_2Panding_3 { get; set; }
        public string xm5_3_1Panding_1 { get; set; }
        public string xm5_3_1Panding_2 { get; set; }
        public string xm5_3_1Panding_3 { get; set; }
        public string xm5_3_1Panding_4 { get; set; }
        public string xm5_3_1Panding_5 { get; set; }
        public string xm5_3_1Panding_6 { get; set; }
        public string xm5_3_1Panding_7 { get; set; }
        public string xm5_3_2Panding_1 { get; set; }
        public string xm5_3_2Panding_2 { get; set; }
        public string xm5_3_2Panding_3 { get; set; }
        public string xm5_3_2Panding_4 { get; set; }
        public string xm5_3_2Panding_5 { get; set; }
        public string xm5_3_2Panding_6 { get; set; }
        public string xm5_3_2Panding_7 { get; set; }
        public string xm5_4_1Panding_1 { get; set; }
        public string xm5_4_1Panding_2 { get; set; }
        public string xm5_4_1Panding_3 { get; set; }
        public string xm5_4_1Panding_4 { get; set; }
        public string xm5_4_1Panding_5 { get; set; }
        public string xm5_4_1Panding_6 { get; set; }
        public string xm5_4_1Panding_7 { get; set; }
        public string xm5_4_1Panding_8 { get; set; }
        public string xm5_4_1Panding_9 { get; set; }
        public string xm5_4_1Panding_10 { get; set; }
        public string xm5_4_1Panding_11 { get; set; }
        public string xm5_4_1Panding_12 { get; set; }
        public string xm5_4_1Panding_13 { get; set; }
        public string xm5_4_1Panding_14 { get; set; }
        public string xm5_4_2Panding_1 { get; set; }
        public string xm5_4_2Panding_2 { get; set; }
        public string xm5_4_2Panding_3 { get; set; }
        public string xm5_4_2Panding_4 { get; set; }
        public string xm5_4_2Panding_5 { get; set; }
        public string xm5_4_2Panding_6 { get; set; }
        public string xm5_4_2Panding_7 { get; set; }
        public string xm5_4_2Panding_8 { get; set; }
        public string xm5_4_2Panding_9 { get; set; }
        public string xm5_4_2Panding_10 { get; set; }
        public string xm5_4_2Panding_11 { get; set; }
        public string xm5_5Panding_1 { get; set; }
        public string xm5_5Panding_2 { get; set; }
        public string xm5_5Panding_3 { get; set; }
        public string xm6_1_1Panding_1 { get; set; }
        public string xm6_1_1Panding_2 { get; set; }
        public string xm6_1_1Panding_3 { get; set; }
        public string xm6_1_1Panding_4 { get; set; }
        public string xm6_1_1Panding_5 { get; set; }
        public string xm6_1_2Panding_1 { get; set; }
        public string xm6_1_2Panding_2 { get; set; }
        public string xm6_1_2Panding_3 { get; set; }
        public string xm6_1_2Panding_4 { get; set; }
        public string xm6_1_2Panding_5 { get; set; }
        public string xm6_1_2Panding_6 { get; set; }
        public string xm6_1_2Panding_7 { get; set; }
        public string xm6_1_2Panding_8 { get; set; }
        public string xm6_1_2Panding_9 { get; set; }
        public string xm6_1_2Panding_10 { get; set; }
        public string xm6_1_3Panding_1 { get; set; }
        public string xm6_1_3Panding_2 { get; set; }
        public string xm6_1_3Panding_3 { get; set; }
        public string xm6_1_3Panding_4 { get; set; }
        public string xm6_1_3Panding_5 { get; set; }
        public string xm6_1_3Panding_6 { get; set; }
        public string xm6_1_4Panding_1 { get; set; }
        public string xm6_1_4Panding_2 { get; set; }
        public string xm6_2_1Panding_1 { get; set; }
        public string xm6_2_1Panding_2 { get; set; }
        public string xm6_2_1Panding_3 { get; set; }
        public string xm6_2_1Panding_4 { get; set; }
        public string xm6_2_1Panding_5 { get; set; }
        public string xm6_2_1Panding_6 { get; set; }
        public string xm6_2_1Panding_7 { get; set; }
        public string xm6_2_1Panding_8 { get; set; }
        public string xm6_2_2Panding_1 { get; set; }
        public string xm6_2_2Panding_2 { get; set; }
        public string xm6_2_2Panding_3 { get; set; }
        public string xm6_2_2Panding_4 { get; set; }
        public string xm6_2_2Panding_5 { get; set; }
        public string xm7_1_1Panding_1 { get; set; }
        public string xm7_1_1Panding_2 { get; set; }
        public string xm7_1_1Panding_3 { get; set; }
        public string xm7_1_1Panding_4 { get; set; }
        public string xm7_1_1Panding_5 { get; set; }
        public string xm7_1_2Panding_1 { get; set; }
        public string xm7_1_2Panding_2 { get; set; }
        public string xm7_1_2Panding_3 { get; set; }
        public string xm7_1_2Panding_4 { get; set; }
        public string xm7_1_2Panding_5 { get; set; }
        public string xm7_1_2Panding_6 { get; set; }
        public string xm7_1_2Panding_7 { get; set; }
        public string xm7_1_2Panding_8 { get; set; }
        public string xm7_1_2Panding_9 { get; set; }
        public string xm7_1_2Panding_10 { get; set; }
        public string xm7_1_2Panding_11 { get; set; }
        public string xm7_1_2Panding_12 { get; set; }
        public string xm7_1_2Panding_13 { get; set; }
        public string xm7_1_2Panding_14 { get; set; }
        public string xm7_1_3Panding_1 { get; set; }
        public string xm7_1_3Panding_2 { get; set; }
        public string xm7_1_4Panding_1 { get; set; }
        public string xm7_1_4Panding_2 { get; set; }
        public string xm7_1_4Panding_3 { get; set; }
        public string xm7_1_4Panding_4 { get; set; }
        public string xm7_1_4Panding_5 { get; set; }
        public string xm7_1_4Panding_6 { get; set; }
        public string xm7_1_4Panding_7 { get; set; }
        public string xm7_1_4Panding_8 { get; set; }
        public string xm7_1_4Panding_9 { get; set; }
        public string xm7_1_4Panding_10 { get; set; }
        public string xm7_1_4Panding_11 { get; set; }
        public string xm7_1_5Panding_1 { get; set; }
        public string xm7_1_5Panding_2 { get; set; }
        public string xm7_1_5Panding_3 { get; set; }
        public string xm7_1_5Panding_4 { get; set; }
        public string xm7_1_5Panding_5 { get; set; }
        public string xm7_1_5Panding_6 { get; set; }
        public string xm7_1_5Panding_7 { get; set; }
        public string xm7_1_5Panding_8 { get; set; }
        public string xm7_1_5Panding_9 { get; set; }
        public string xm7_1_6Panding_1 { get; set; }
        public string xm7_1_6Panding_2 { get; set; }
        public string xm7_1_6Panding_3 { get; set; }
        public string xm7_1_6Panding_4 { get; set; }
        public string xm7_1_6Panding_5 { get; set; }
        public string xm7_1_6Panding_6 { get; set; }
        public string xm7_2_1Panding_1 { get; set; }
        public string xm7_2_1Panding_2 { get; set; }
        public string xm7_2_1Panding_3 { get; set; }
        public string xm7_2_1Panding_4 { get; set; }
        public string xm7_2_1Panding_5 { get; set; }
        public string xm7_2_2Panding_1 { get; set; }
        public string xm7_2_2Panding_2 { get; set; }
        public string xm7_2_2Panding_3 { get; set; }
        public string xm7_2_2Panding_4 { get; set; }
        public string xm7_2_2Panding_5 { get; set; }
        public string xm7_2_2Panding_6 { get; set; }
        public string xm7_2_2Panding_7 { get; set; }
        public string xm7_2_2Panding_8 { get; set; }
        public string xm7_2_2Panding_9 { get; set; }
        public string xm7_2_2Panding_10 { get; set; }
        public string xm7_2_2Panding_11 { get; set; }
        public string xm7_2_2Panding_12 { get; set; }
        public string xm7_2_3Panding_1 { get; set; }
        public string xm7_2_3Panding_2 { get; set; }
        public string xm7_2_4Panding_1 { get; set; }
        public string xm7_2_4Panding_2 { get; set; }
        public string xm7_2_4Panding_3 { get; set; }
        public string xm7_2_4Panding_4 { get; set; }
        public string xm7_2_4Panding_5 { get; set; }
        public string xm7_2_4Panding_6 { get; set; }
        public string xm7_2_4Panding_7 { get; set; }
        public string xm7_2_4Panding_8 { get; set; }
        public string xm7_2_4Panding_9 { get; set; }
        public string xm7_2_4Panding_10 { get; set; }
        public string xm7_2_4Panding_11 { get; set; }
        public string xm7_2_5Panding_1 { get; set; }
        public string xm7_2_5Panding_2 { get; set; }
        public string xm7_2_5Panding_3 { get; set; }
        public string xm7_2_6Panding_1 { get; set; }
        public string xm7_2_6Panding_2 { get; set; }
        public string xm7_2_6Panding_3 { get; set; }
        public string xm7_2_6Panding_4 { get; set; }
        public string xm7_2_6Panding_5 { get; set; }
        public string xm7_2_6Panding_6 { get; set; }
        public string xm7_2_6Panding_7 { get; set; }
        public string xm7_2_6Panding_8 { get; set; }
        public string xm7_2_6Panding_9 { get; set; }
        public string xm7_2_7Panding_1 { get; set; }
        public string xm7_2_7Panding_2 { get; set; }
        public string xm7_2_7Panding_3 { get; set; }
        public string xm7_2_7Panding_4 { get; set; }
        public string xm8_1_1Panding_1 { get; set; }
        public string xm8_1_1Panding_2 { get; set; }
        public string xm8_1_1Panding_3 { get; set; }
        public string xm8_1_1Panding_4 { get; set; }
        public string xm8_1_1Panding_5 { get; set; }
        public string xm8_1_1Panding_6 { get; set; }
        public string xm8_1_1Panding_7 { get; set; }
        public string xm8_1_1Panding_8 { get; set; }
        public string xm8_1_1Panding_9 { get; set; }
        public string xm8_1_1Panding_10 { get; set; }
        public string xm8_1_2Panding_1 { get; set; }
        public string xm8_1_2Panding_2 { get; set; }
        public string xm8_1_2Panding_3 { get; set; }
        public string xm8_1_2Panding_4 { get; set; }
        public string xm8_1_2Panding_5 { get; set; }
        public string xm8_1_2Panding_6 { get; set; }
        public string xm8_1_2Panding_7 { get; set; }
        public string xm8_1_2Panding_8 { get; set; }
        public string xm8_1_3Panding_1 { get; set; }
        public string xm8_1_3Panding_2 { get; set; }
        public string xm8_1_3Panding_3 { get; set; }
        public string xm8_1_3Panding_4 { get; set; }
        public string xm8_2_1Panding_1 { get; set; }
        public string xm8_2_1Panding_2 { get; set; }
        public string xm8_2_1Panding_3 { get; set; }
        public string xm8_2_1Panding_4 { get; set; }
        public string xm8_2_1Panding_5 { get; set; }
        public string xm8_2_1Panding_6 { get; set; }
        public string xm8_2_1Panding_7 { get; set; }
        public string xm8_2_1Panding_8 { get; set; }
        public string xm8_2_1Panding_9 { get; set; }
        public string xm8_2_2Panding_1 { get; set; }
        public string xm8_2_2Panding_2 { get; set; }
        public string xm8_2_2Panding_3 { get; set; }
        public string xm8_2_2Panding_4 { get; set; }
        public string xm8_2_3Panding_1 { get; set; }
        public string xm8_2_3Panding_2 { get; set; }
        public string xm8_2_3Panding_3 { get; set; }
        public string xm8_2_3Panding_4 { get; set; }
        public string xm8_2_3Panding_5 { get; set; }
        public string xm8_2_3Panding_6 { get; set; }
        public string xm8_2_3Panding_7 { get; set; }
        public string xm8_2_3Panding_8 { get; set; }
        public string xm8_2_3Panding_9 { get; set; }
        public string xm8_2_3Panding_10 { get; set; }
        public string xm8_2_3Panding_11 { get; set; }
        public string xm8_2_3Panding_12 { get; set; }
        public string xm8_2_3Panding_13 { get; set; }
        public string xm8_2_3Panding_14 { get; set; }
        public string xm8_2_4Panding_1 { get; set; }
        public string xm8_2_4Panding_2 { get; set; }
        public string xm8_2_4Panding_3 { get; set; }
        public string xm8_2_4Panding_4 { get; set; }
        public string xm8_2_4Panding_5 { get; set; }
        public string xm8_2_4Panding_6 { get; set; }
        public string xm8_2_4Panding_7 { get; set; }
        public string xm8_2_5Panding_1 { get; set; }
        public string xm8_2_5Panding_2 { get; set; }
        public string xm8_2_5Panding_3 { get; set; }
        public string xm8_2_5Panding_4 { get; set; }
        public string xm8_2_6Panding_1 { get; set; }
        public string xm8_2_6Panding_2 { get; set; }
        public string xm9_1Panding_1 { get; set; }
        public string xm9_1Panding_2 { get; set; }
        public string xm9_1Panding_3 { get; set; }
        public string xm9_1Panding_4 { get; set; }
        public string xm9_1Panding_5 { get; set; }
        public string xm9_2_1Panding_1 { get; set; }
        public string xm9_2_1Panding_2 { get; set; }
        public string xm9_2_2Panding_1 { get; set; }
        public string xm9_2_2Panding_2 { get; set; }
        public string xm9_3_1Panding_1 { get; set; }
        public string xm9_3_1Panding_2 { get; set; }
        public string xm9_3_1Panding_3 { get; set; }
        public string xm9_3_2Panding_1 { get; set; }
        public string xm9_3_2Panding_2 { get; set; }
        public string xm9_4_1Panding_1 { get; set; }
        public string xm9_4_1Panding_2 { get; set; }
        public string xm9_4_1Panding_3 { get; set; }
        public string xm9_4_1Panding_4 { get; set; }
        public string xm9_4_2Panding_1 { get; set; }
        public string xm9_4_2Panding_2 { get; set; }
        public string xm9_4_2Panding_3 { get; set; }
        public string xm9_4_2Panding_4 { get; set; }
        public string xm9_4_3Panding_1 { get; set; }
        public string xm9_4_3Panding_2 { get; set; }
        public string xm9_4_3Panding_3 { get; set; }
        public string xm9_4_3Panding_4 { get; set; }
        public string xm9_4_4Panding_1 { get; set; }
        public string xm9_4_4Panding_2 { get; set; }
        public string xm9_4_4Panding_3 { get; set; }
        public string xm9_4_4Panding_4 { get; set; }
        public string xm9_5Panding_1 { get; set; }
        public string xm9_5Panding_2 { get; set; }
        public string xm9_5Panding_3 { get; set; }
        public string xm9_5Panding_4 { get; set; }
        public string xm9_5Panding_5 { get; set; }
        public string xm9_5Panding_6 { get; set; }
        public string xm9_5Panding_7 { get; set; }
        public string xm9_5Panding_8 { get; set; }
        public string xm9_5Panding_9 { get; set; }
        public string xm9_5Panding_10 { get; set; }
        public string xm9_5Panding_11 { get; set; }
        public string xm9_6_1Panding_1 { get; set; }
        public string xm9_6_1Panding_2 { get; set; }
        public string xm9_6_2Panding_1 { get; set; }
        public string xm9_6_2Panding_2 { get; set; }
        public string xm9_6_2Panding_3 { get; set; }
        public string xm9_6_3Panding_1 { get; set; }
        public string xm9_6_3Panding_2 { get; set; }
        public string xm9_6_3Panding_3 { get; set; }
        public string xm9_6_4Panding_1 { get; set; }
        public string xm9_6_4Panding_2 { get; set; }
        public string xm9_6_4Panding_3 { get; set; }
        public string xm9_6_4Panding_4 { get; set; }
        public string xm9_6_5Panding_1 { get; set; }
        public string xm9_6_5Panding_2 { get; set; }
        public string xm9_7_1Panding_1 { get; set; }
        public string xm9_7_1Panding_2 { get; set; }
        public string xm9_7_1Panding_3 { get; set; }
        public string xm9_7_1Panding_4 { get; set; }
        public string xm9_7_1Panding_5 { get; set; }
        public string xm9_7_1Panding_6 { get; set; }
        public string xm9_7_1Panding_7 { get; set; }
        public string xm9_7_1Panding_8 { get; set; }
        public string xm9_7_1Panding_9 { get; set; }
        public string xm9_7_1Panding_10 { get; set; }
        public string xm9_7_2Panding_1 { get; set; }
        public string xm9_7_2Panding_2 { get; set; }
        public string xm9_8Panding_1 { get; set; }
        public string xm9_8Panding_2 { get; set; }
        public string xm9_8Panding_3 { get; set; }
        public string xm9_8Panding_4 { get; set; }
        public string xm9_8Panding_5 { get; set; }
        public string xm9_8Panding_6 { get; set; }
        public string xm10_1Panding_1 { get; set; }
        public string xm10_1Panding_2 { get; set; }
        public string xm10_1Panding_3 { get; set; }
        public string xm10_1Panding_4 { get; set; }
        public string xm10_1Panding_5 { get; set; }
        public string xm10_2Panding_1 { get; set; }
        public string xm10_2Panding_2 { get; set; }
        public string xm10_2Panding_3 { get; set; }
        public string xm10_2Panding_4 { get; set; }
        public string xm10_2Panding_5 { get; set; }
        public string xm10_2Panding_6 { get; set; }
        public string xm10_2Panding_7 { get; set; }
        public string xm10_3Panding_1 { get; set; }
        public string xm10_3Panding_2 { get; set; }
        public string xm10_4Panding_1 { get; set; }
        public string xm10_4Panding_2 { get; set; }
        public string xm10_5Panding_1 { get; set; }
        public string xm10_5Panding_2 { get; set; }
        public string xm10_5Panding_3 { get; set; }
        public string xm10_5Panding_4 { get; set; }
        public string xm10_5Panding_5 { get; set; }
        public string xm10_5Panding_6 { get; set; }
        public string xm10_5Panding_7 { get; set; }
        public string xm10_5Panding_8 { get; set; }
        public string xm10_5Panding_9 { get; set; }
        public string xm10_5Panding_10 { get; set; }
        public string xm11_1Panding_1 { get; set; }
        public string xm11_1Panding_2 { get; set; }
        public string xm11_1Panding_3 { get; set; }
        public string xm11_1Panding_4 { get; set; }
        public string xm11_2Panding_1 { get; set; }
        public string xm11_2Panding_2 { get; set; }
        public string xm11_2Panding_3 { get; set; }
        public string xm11_3Panding_1 { get; set; }
        public string xm11_3Panding_2 { get; set; }
        public string xm11_3Panding_3 { get; set; }
        public string xm12_1Panding_1 { get; set; }
        public string xm12_1Panding_2 { get; set; }
        public string xm12_1Panding_3 { get; set; }
        public string xm12_1Panding_4 { get; set; }
        public string xm12_2_1Panding_1 { get; set; }
        public string xm12_2_1Panding_2 { get; set; }
        public string xm12_2_2Panding_1 { get; set; }
        public string xm12_2_2Panding_2 { get; set; }
        public string xm12_2_2Panding_3 { get; set; }
        public string xm12_2_2Panding_4 { get; set; }
        public string xm12_3Panding_1 { get; set; }
        public string xm12_3Panding_2 { get; set; }
        public string xm12_3Panding_3 { get; set; }
        public string xm13_1Panding_1 { get; set; }
        public string xm13_1Panding_2 { get; set; }
        public string xm13_2Panding_1 { get; set; }
        public string xm13_2Panding_2 { get; set; }
        public string xm13_2Panding_3 { get; set; }
        public string xm13_3Panding_1 { get; set; }
        public string xm13_3Panding_2 { get; set; }
        public string xm3_1_1Panding { get; set; }
        public string xm3_1_2Panding { get; set; }
        public string xm3_2_1Panding { get; set; }
        public string xm3_2_2Panding { get; set; }
        public string xm3_2_3Panding { get; set; }
        public string xm3_2_4Panding { get; set; }
        public string xm4_1_1Panding { get; set; }
        public string xm4_1_2Panding { get; set; }
        public string xm4_2_1Panding { get; set; }
        public string xm4_2_2Panding { get; set; }
        public string xm4_3Panding { get; set; }
        public string xm5_1_1Panding { get; set; }
        public string xm5_1_2Panding { get; set; }
        public string xm5_2_1Panding { get; set; }
        public string xm5_2_2Panding { get; set; }
        public string xm5_3_1Panding { get; set; }
        public string xm5_3_2Panding { get; set; }
        public string xm5_4_1Panding { get; set; }
        public string xm5_4_2Panding { get; set; }
        public string xm5_5Panding { get; set; }
        public string xm6_1_1Panding { get; set; }
        public string xm6_1_2Panding { get; set; }
        public string xm6_1_3Panding { get; set; }
        public string xm6_1_4Panding { get; set; }
        public string xm6_2_1Panding { get; set; }
        public string xm6_2_2Panding { get; set; }
        public string xm7_1_1Panding { get; set; }
        public string xm7_1_2Panding { get; set; }
        public string xm7_1_3Panding { get; set; }
        public string xm7_1_4Panding { get; set; }
        public string xm7_1_5Panding { get; set; }
        public string xm7_1_6Panding { get; set; }
        public string xm7_2_1Panding { get; set; }
        public string xm7_2_2Panding { get; set; }
        public string xm7_2_3Panding { get; set; }
        public string xm7_2_4Panding { get; set; }
        public string xm7_2_5Panding { get; set; }
        public string xm7_2_6Panding { get; set; }
        public string xm7_2_7Panding { get; set; }
        public string xm8_1_1Panding { get; set; }
        public string xm8_1_2Panding { get; set; }
        public string xm8_1_3Panding { get; set; }
        public string xm8_2_1Panding { get; set; }
        public string xm8_2_2Panding { get; set; }
        public string xm8_2_3Panding { get; set; }
        public string xm8_2_4Panding { get; set; }
        public string xm8_2_5Panding { get; set; }
        public string xm8_2_6Panding { get; set; }
        public string xm9_1Panding { get; set; }
        public string xm9_2_1Panding { get; set; }
        public string xm9_2_2Panding { get; set; }
        public string xm9_3_1Panding { get; set; }
        public string xm9_3_2Panding { get; set; }
        public string xm9_4_1Panding { get; set; }
        public string xm9_4_2Panding { get; set; }
        public string xm9_4_3Panding { get; set; }
        public string xm9_4_4Panding { get; set; }
        public string xm9_5Panding { get; set; }
        public string xm9_6_1Panding { get; set; }
        public string xm9_6_2Panding { get; set; }
        public string xm9_6_3Panding { get; set; }
        public string xm9_6_4Panding { get; set; }
        public string xm9_6_5Panding { get; set; }
        public string xm9_7_1Panding { get; set; }
        public string xm9_7_2Panding { get; set; }
        public string xm9_8Panding { get; set; }
        public string xm10_1Panding { get; set; }
        public string xm10_2Panding { get; set; }
        public string xm10_3Panding { get; set; }
        public string xm10_4Panding { get; set; }
        public string xm10_5Panding { get; set; }
        public string xm11_1Panding { get; set; }
        public string xm11_2Panding { get; set; }
        public string xm11_3Panding { get; set; }
        public string xm12_1Panding { get; set; }
        public string xm12_2_1Panding { get; set; }
        public string xm12_2_2Panding { get; set; }
        public string xm12_3Panding { get; set; }
        public string xm13_1Panding { get; set; }
        public string xm13_2Panding { get; set; }
        public string xm13_3Panding { get; set; }
    }
    //使用JsonConvert方式需要Newtonsoft.dll;引用Newtonsoft.Json，frameword2.0也可以用
    //字符串转json
    public static void strJson()
    {
        //string jsonText = "{\"ids\":\"深圳\"}";
        ////转为json对象
        //Student jo = JsonConvert.DeserializeObject<Student>(jsonText);//反序列化;
        //string zone = jo.ids.ToString();//输出 深圳

        //Console.WriteLine(jo);
        //Console.WriteLine(zone);
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
    /// <summary>
    /// 列出path路径对应的文件夹中的子文件
    /// </summary>
    /// <param name="path">需要列出内容的文件夹的路径</param>
    public List<string> listDirectory(string path)
    {
        DirectoryInfo theFolder = new DirectoryInfo(@path);
        List<string> files=new List<string>();


        //遍历文件
        foreach (System.IO.FileInfo NextFile in theFolder.GetFiles())
        {
            files.Add(NextFile.Name );
        }

        return files;


    }




}