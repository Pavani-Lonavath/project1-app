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
    <title>Harman Gill CS 6320 Project1 </title>
 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

<!-- Optional theme -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous">

<!-- Latest compiled and minified JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

 <style>
 .well{
background-color: rgb(2, 15, 13);
}
 </style>
<meta charset="UTF-8">
</head>
<body>

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

<div class="container">
<div class = "panel panel-info">
   <div class = "panel-heading">
      <h3 class = "panel-title">Top Tweets </h3>
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
    Query query = new Query("Tweet").addSort("count", Query.SortDirection.DESCENDING);;
    query.addFilter("fb_userid",
            Query.FilterOperator.EQUAL,
            fb_userid);
    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
    int num_tweets = tweets.size();
    if (tweets.isEmpty()) {
%>
<div class="alert alert-danger"> <p> No  tweets found in datastore</p>
</div>
<%
}
else { 

	for (Entity tweet : tweets) { 
		String tweet_text =  (String) tweet.getProperty("tweet");
		String tweet_date = (String) tweet.getProperty("date");
		String user_name = (String) tweet.getProperty("fb_username");
		String key = KeyFactory.keyToString(tweet.getKey());
		String href = "'view.jsp?t_key=" + key + "'";
		Long count = (Long) tweet.getProperty("count");
		String pic = (String) tweet.getProperty("pic_link");
		
%>


<div><span class = "label label-default">Tweet:</span> <a href=<%=href %>> <%=tweet_text %> </a>  </div><br>
<div><span class = "label label-primary">Posted on:</span>  <%=tweet_date %> </div><br>
<div><span class = "label label-warning">View Count:</span> <%=count %> </div><br>
<hr />

<% }} %>

</div>


   </div>
</div>


</div>


</body>
</html>