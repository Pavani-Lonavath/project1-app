package cs6320;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.SimpleTimeZone;
import javax.servlet.http.*;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.KeyFactory;


@SuppressWarnings("serial")
public class NewTweet extends HttpServlet {
    public void doGet(HttpServletRequest req,
                      HttpServletResponse resp)
        throws IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSSSSS");
        fmt.setTimeZone(new SimpleTimeZone(0, ""));
        String date = fmt.format(new Date());
        String tweet = req.getParameter("tweet");
        String fb_userid =req.getParameter("fb_userid");
        String fb_username =req.getParameter("fb_username");
        String pic_link =req.getParameter("pic_link");
        String msg = req.getParameter("msg");
        int count = 0;


        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

        Entity newtweet = new Entity("Tweet");

        newtweet.setProperty("tweet", tweet);
        newtweet.setProperty("fb_userid", fb_userid);
        newtweet.setProperty("date", date);
        newtweet.setProperty("fb_username", fb_username);
        newtweet.setProperty("pic_link", pic_link);
        newtweet.setProperty("count", count);
        ds.put(newtweet);
        String key = KeyFactory.keyToString(newtweet.getKey());
        if (msg != null || msg == "true") {
        	out.print(key);
        }
        else {
        resp.sendRedirect("/");
        }
    }
 
    public void doPost(HttpServletRequest req,
            HttpServletResponse resp) throws IOException {
    	doGet(req,resp);
    }
}