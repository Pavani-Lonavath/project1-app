<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Harman CS6320 Project1 </title>
 
 <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
 
<meta charset="UTF-8">
</head>
<body>
 <div id="fb-root"></div>
<script>
function statusChangeCallback(response) {
console.log('statusChangeCallback');
console.log(response);

if (response.status === 'connected') {
// Logged into your app and Facebook.
var msg=document.getElementById('dashboard');
msg.style.display='';
var login_div=document.getElementById('status');
login_div.style.display='none';

testAPI();
} 
else if (response.status === 'not_authorized') {
// The person is logged into Facebook, but not your app.
	var msg=document.getElementById('dashboard');
	msg.style.display='none';
	var login_div=document.getElementById('status');
	login_div.style.display='';


} else {
	var msg=document.getElementById('dashboard');
	msg.style.display='';
	var login_div=document.getElementById('status');
	login_div.style.display='none';
}
}

  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }


window.fbAsyncInit = function() {
    FB.init({
   	appId      : '228541170975792',
      cookie     : true,  // enable cookies to allow the server to access 
      // the session
      xfbml      : true,
      version    : 'v2.1'
    });  
    
FB.getLoginStatus(function(response) {
	    statusChangeCallback(response);
	  });
	  };
	  
(function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));



var fb_userid = "";
var fb_username = "";
var pic_link="";

function testAPI() {

FB.api('/me', function(response) {

document.getElementById('picture_show').innerHTML = '<a href="#" class="pull-left"><img class="media-object" src="http://graph.facebook.com/' + response.id + '/picture?type=large" /></a>';
document.getElementById('profile_name').innerText = response.name;
pic_link  = 'http://graph.facebook.com/' + response.id + '/picture';
fb_userid  =  response.id;
fb_username = response.name.split(" ")[0];
document.cookie = "fb_userid=" + response.id;

});
}


var del_tweet = function() {
	var tweet= document.getElementById('key_id').value;
		var post_data = {
				  key_id : tweet
				};
		$.post( "Delete", post_data, function(data) {
		    alert('Success ! Tweet deleted from GAE');
		    location.reload();
		});
		

		
	}


function share_message() {
	var tweet_value= document.getElementById('create_tweet').value;
	var post_data = {
			  tweet: tweet_value,
			  fb_userid: fb_userid  , 
			  fb_username: fb_username,
			 pic_link: pic_link,
			 msg : "true"
			};
	console.log(post_data);
	$.post( "NewTweet", post_data, function(data) {
		var key = data;
		var url = window.location.href ;
		if (url.search("localhost")!==-1) {
			url = "https://facebook.com/";
		}
		var share_url = url + "view.jsp?t_key=" + key ;
		
		var dict = {
				  method: 'send',
				  link: share_url  , 
				  caption: 'tweet',
				 description: 'Dialogs provide a simple, consistent interface for applications to interface with users.'
				   
				};

	FB.ui(dict ,function(response) {

				     if (response && response.success) {
				       alert('Success: shared to message.');
				       location.reload();
				     } else {
				       alert('Error posting via message');
				       console.log(response);
				     }
				   });	
	
	});
	


}



var share_timeline = function() {
var tweet= document.getElementById('create_tweet').value;
	var post_data = {
			  tweet: tweet,
			  fb_userid: fb_userid, 
			  fb_username: fb_username,
			 pic_link: pic_link,
			 msg : "false"
			};
	console.log(post_data);
	$.post( "NewTweet", post_data, function(data) {
	
	FB.api('/me/feed', 'post', { message: tweet }, function(response) {
		  if (!response || response.error) {
		    alert('Error occured due to: ' + response.error.message);
		    console.log(response.error.message);
		  } else {
		    alert('Posted to timeline. Post ID is ' + response.id);
		    location.reload();
		  }
		});
	
	});
	

	
}


</script>


<div id ="status" class="jumbotron">
  <h1>Project 1 CS6320 fb tweet App </h1>
  <p>Login to use this App .</p>
<fb:login-button size="xlarge" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
</fb:login-button>
</div>
<fb:login-button size="xlarge" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
</fb:login-button>



<nav class="navbar navbar-inverse">
<div class="container-fluid">

<div class="navbar-header">
<a href="#" class="navbar-brand"> Harman Gill CS6320 Project1 </a>
</div>

<div>
<ul class="nav navbar-nav">
	<li class="active"> <a href="index.jsp"> Home </a></li>
	<li><a href="friends_page.jsp">Tweets by Friends </a></li>
	<li><a href="top_tweets_page.jsp">Most Visited tweets </a></li>
</ul>
</div>

</div>
</nav>

<div id="dashboard" class="container" style="display:none;">
<div class="offset4">
<p class="lead">WELCOME </p>
<div class="row">
<div class="well">
<div class="form-group">
      <textarea class="span4 form-control" id="create_tweet" name="create_tweet" rows="5" placeholder="Create a tweet and share..."></textarea>
        <input type="submit" name="share_timeline" value="Share tweet on timeline" class="btn btn-primary" onclick="share_timeline()"/>
        <input type="button" name="share_message" value="Send tweet link as message" class="btn btn-warning" onclick="share_message()"/>
</div>
</div>
</div>
</div>


<div class = "panel panel-default">
   <div class = "panel-heading">
      <h3 class = "panel-title">
         Profile Info 
      </h3>
   </div>
   
   <div class = "panel-body">
      <h2 id="profile_name"> </h2>
      <a href = "#">Total Tweets <span class="badge" id="sum_tweets">0</span></a>
      <div id="picture_show" class = "media">
   		<a class = "pull-left" href = "#">
      		<img class = "media-object" src = "" alt = "Media Object">
   		</a>
   	</div>
   </div>
</div>


<div class = "panel panel-primary">
   <div class = "panel-heading">
      <h3 class = "panel-title">Old Tweets </h3>
   </div>
   
   <div class = "panel-body">
<div class="span4" style="overflow-y: scroll; height:400px;">





<%
 Cookie[] cookies = request.getCookies();
String fb_userid="";
if (cookies != null) {
	for (int i = 0; i < cookies.length; i++) {
		Cookie cookie = cookies[i];
		if (cookie.getName().equals("fb_userid")) {
			fb_userid = cookie.getValue();
		}


	}
}
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Tweet").addSort("date", Query.SortDirection.DESCENDING);
    query.addFilter("fb_userid",
            Query.FilterOperator.EQUAL,
            fb_userid);
    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
    int sum_tweets = tweets.size();
    if (tweets.isEmpty()) {
%>
<div class="alert alert-danger"> <p> No old tweets found from GAE datastore</p>
</div>
<%
}
else { 
%>
	<script type="text/javascript"> console.log(<%=sum_tweets%>);document.getElementById("sum_tweets").innerText = "<%=sum_tweets%> tweets";</script>
<% 
	for (Entity tweet : tweets) { 
		String tweet_status =  (String) tweet.getProperty("tweet");
		String tweet_date = (String) tweet.getProperty("date");
		String key = KeyFactory.keyToString(tweet.getKey());
		String href = "'view.jsp?t_key=" + key + "'";
		Long count = (Long) tweet.getProperty("count");
%>


<div><span class = "label label-default">Tweet:</span> <a href=<%=href%> > <%=tweet_status%> </a>  </div><br>
<div><span class = "label label-warning">Posted on:</span>  <%=tweet_date%> </div><br>
<div><span class = "label label-primary">View Count:</span> <%=count %> </div><br>
<input type="hidden" name="key_id" id="key_id" value="<%=key%>"/>    

<input type="submit" class="btn btn-danger" value="Delete" onclick="del_tweet()"/>
<hr />
<% } %>
<% }  %>





</div>


   </div>
</div>


</div>

</body>
</html>