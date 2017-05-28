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
 
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
<a href="#" class="navbar-brand"> CS6320 Project1 by </a>
</div>

<div>
<ul class="nav navbar-nav">
	<li class="active"> <a href="#"> Home </a></li>
	<li><a href="friends_tweet.jsp">Friends Tweets</a></li>
	<li><a href="top_tweets.jsp">Top Tweets </a></li>
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
    Query query = new Query("Tweet").addSort("count", Query.SortDirection.DESCENDING);;
    query.addFilter("user_id",
            Query.FilterOperator.EQUAL,
            user_id);
    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
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
		String user_name = (String) tweet.getProperty("user_name");
		String key = KeyFactory.keyToString(tweet.getKey());
		String href = "'view.jsp?t_key=" + key + "'";
		Long count = (Long) tweet.getProperty("count");
		String pic = (String) tweet.getProperty("pic");
		
%>


<div><span class = "label label-success">Tweet:</span> <a href=<%=href %>> <%=tweet_text %> </a>  </div><br>
<div><span class = "label label-primary">Posted on:</span>  <%=tweet_date %> </div><br>
<div><span class = "label label-info">View Count:</span> <%=count %> </div><br>
<hr />

<% }} %>

</div>


   </div>
</div>


</div>


</body>
</html>