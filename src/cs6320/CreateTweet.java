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
public class CreateTweet extends HttpServlet {
    public void doGet(HttpServletRequest req,
                      HttpServletResponse resp)
        throws IOException {
        resp.setContentType("text/html");
        PrintWriter out = resp.getWriter();
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.SSSSSS");
        fmt.setTimeZone(new SimpleTimeZone(0, ""));
        String date = fmt.format(new Date());
        String tweet = req.getParameter("tweet");
        String user_id =req.getParameter("user_id");
        String user_name =req.getParameter("user_name");
        String pic =req.getParameter("pic");
        String massenger = req.getParameter("massenger");
        int count = 0;


        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

        Entity atweet = new Entity("Tweet");

        atweet.setProperty("tweet", tweet);
        atweet.setProperty("user_id", user_id);
        atweet.setProperty("date", date);
        atweet.setProperty("user_name", user_name);
        atweet.setProperty("pic", pic);
        atweet.setProperty("count", count);
        ds.put(atweet);
        String key = KeyFactory.keyToString(atweet.getKey());
        if (massenger != null || massenger == "true") {
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