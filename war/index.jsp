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
    <title>CS 6320 Project 1 </title>
 
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
// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
console.log('statusChangeCallback');
console.log(response);
// The response object is returned with a status field that lets the
// app know the current login status of the person.
// Full docs on the response object can be found in the documentation
// for FB.getLoginStatus().
if (response.status === 'connected') {
// Logged into your app and Facebook.
var msg=document.getElementById('tweet_box');
msg.style.display='';
var login_div=document.getElementById('status');
login_div.style.display='none';

testAPI();
} 
else if (response.status === 'not_authorized') {
// The person is logged into Facebook, but not your app.
	var msg=document.getElementById('tweet_box');
	msg.style.display='none';
	var login_div=document.getElementById('status');
	login_div.style.display='';


} else {
// The person is not logged into Facebook, so we're not sure if
// they are logged into this app or not.
	var msg=document.getElementById('tweet_box');
	msg.style.display='';
	var login_div=document.getElementById('status');
	login_div.style.display='none';
}
}

// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }


window.fbAsyncInit = function() {
    FB.init({
   	appId      : '685563044963492',
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



var delete_tweet = function() {
	var tweet= document.getElementById('tweet_key').value;
		var post_data = {
				  tweet_key: tweet
				};
		$.post( "Delete", post_data, function(data) {
		    alert('Tweet Deleted successfully');
		    location.reload();
		});
		

		
	}




var post = function() {
var tweet= document.getElementById('tweet_text').value;
	var post_data = {
			  tweet: tweet,
			  user_id: user_id  , 
			  user_name: user_name,
			 pic: pic,
			 massenger : "false"
			};
	$.post( "CreateTweet", post_data, function(data) {
	
	FB.api('/me/feed', 'post', { message: tweet }, function(response) {
		  if (!response || response.error) {
		    alert('Error occured due to: ' + response.error.message);
		    console.log(response.error.message);
		  } else {
		    alert('Post ID: ' + response.id);
		    location.reload();
		  }
		});
	
	});
	

	
}
// Here we run a very simple test of the Graph API after login is
// successful. See statusChangeCallback() for when this call is made.
function share() {
	var tweet= document.getElementById('tweet_text').value;
	var post_data = {
			  tweet: tweet,
			  user_id: user_id  , 
			  user_name: user_name,
			 pic: pic,
			 massenger : "true"
			};
	$.post( "CreateTweet", post_data, function(data) {
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
				       alert('Post was shared via message.');
				       location.reload();
				     } else {
				       alert('Post was not published due to error');
				       console.log(response);
				     }
				   });	
	
	});
	


}

var user_id = "";
var user_name = "";
var pic="";

function testAPI() {

console.log('Welcome! Fetching your information.... ');
FB.api('/me', function(response) {
console.log('Successful login for: ' + response.name);

console.log('response is ' + JSON.stringify(response));
document.getElementById('picture_show').innerHTML = '<a href="#" class="pull-left"><img class="media-object" src="http://graph.facebook.com/' + response.id + '/picture?type=large" /></a>';
document.getElementById('profile_name').innerText = response.name;
pic  = 'http://graph.facebook.com/' + response.id + '/picture';
user_id  =  response.id;
user_name = response.name.split(" ")[0];
document.cookie = "user_id=" + response.id;

});
}
</script>

<!--
Below we include the Login Button social plugin. This button uses
the JavaScript SDK to present a graphical Login button that triggers
the FB.login() function when clicked.
-->

<div id ="status" class="jumbotron">
  <h1>Welcome to CS6320 Project1 FB Twitter App </h1>
  <p>You must login to continue...</p>
<fb:login-button size="xlarge" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
</fb:login-button>
</div>
<fb:login-button size="xlarge" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
</fb:login-button>



<nav class="navbar navbar-inverse">
<div class="container-fluid">

<div class="navbar-header">
<a href="#" class="navbar-brand"> CS6320 Project1 by </a>
</div>

<div>
<ul class="nav navbar-nav">
	<li class="active"> <a href="index.jsp"> Home </a></li>
	<li><a href="friends_tweet.jsp">Friends Tweets</a></li>
	<li><a href="top_tweets.jsp">Top Tweets </a></li>
</ul>
</div>

</div>
</nav>

<div id="tweet_box" class="container" style="display:none;">
<div class="offset4">
<p class="lead">Hello There </p>
<div class="row">
<div class="well">
<div class="form-group">
      <textarea class="span4 form-control" id="tweet_text" name="tweet_text" rows="5" placeholder="New Status post here"></textarea>
        <input type="submit" name="post_button" value="Post New Status" class="btn btn-info" onclick="post()"/>
        <input type="button" name="share_button" value="Share via Message" class="btn btn-success" onclick="share()"/>
</div>
</div>
</div>
</div>


<div class = "panel panel-success">
   <div class = "panel-heading">
      <h3 class = "panel-title">
         Profile Info 
      </h3>
   </div>
   
   <div class = "panel-body">
      <h2 id="profile_name"> </h2>
      <a href = "#">Number of tweets <span class="badge" id="total_tweets">0</span></a>
      <div id="picture_show" class = "media">
   		<a class = "pull-left" href = "#">
      		<img class = "media-object" src = "" alt = "Media Object">
   		</a>
   	</div>
   </div>
</div>


<div class = "panel panel-info">
   <div class = "panel-heading">
      <h3 class = "panel-title">Previous Tweets </h3>
   </div>
   
   <div class = "panel-body">
<div class="span4" style="overflow-y: scroll; height:400px;">





<%
 Cookie[] cookies = request.getCookies();
String user_id="";
if (cookies != null) {
	for (int i = 0; i < cookies.length; i++) {
		Cookie cookie = cookies[i];
		if (cookie.getName().equals("user_id")) {
			user_id = cookie.getValue();
		}


	}
}
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    // Run an ancestor query to ensure we see the most up-to-date
    // view of the Greetings belonging to the selected Guestbook.
    Query query = new Query("Tweet").addSort("date", Query.SortDirection.DESCENDING);
    query.addFilter("user_id",
            Query.FilterOperator.EQUAL,
            user_id);
    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
    int num_tweets = tweets.size();
    if (tweets.isEmpty()) {
%>
<div class="alert alert-danger"> <p> No tweets found in datastore</p>
</div>
<%
}
else { 
%>
	<script type="text/javascript"> console.log(<%=num_tweets%>);document.getElementById("total_tweets").innerText = "<%=num_tweets%> tweets";</script>
<% 
	for (Entity tweet : tweets) { 
		String tweet_text =  (String) tweet.getProperty("tweet");
		String tweet_date = (String) tweet.getProperty("date");
		String key = KeyFactory.keyToString(tweet.getKey());
		String href = "'view.jsp?t_key=" + key + "'";
		Long count = (Long) tweet.getProperty("count");
%>


<div><span class = "label label-success">Tweet:</span> <a href=<%=href%> > <%=tweet_text%> </a>  </div><br>
<div><span class = "label label-primary">Posted on:</span>  <%=tweet_date%> </div><br>
<div><span class = "label label-info">View Count:</span> <%=count %> </div><br>
<input type="hidden" name="tweet_key" id="tweet_key" value="<%=key%>"/>    

<input type="submit" class="btn btn-danger" value="Delete" onclick="delete_tweet()"/>
<hr />
<% } %>
<% }  %>





</div>


   </div>
</div>


</div>

</body>
</html>