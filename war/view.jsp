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
      <h3 class = "panel-title">View a tweet  </h3>
   </div>

   <div class = "panel-body">
<div class="span4" style="overflow-y: scroll; height:400px;">



  <%
    String t_key = request.getParameter("t_key");
    if (t_key == null) {
    	out.print("no tweet key given");
    	%>
    	<script type="text/javascript"> msg= "Error no Tweet key provided, going back to hompage...";console.log(msg);alert(msg); location.href="index.jsp";</script>
    <%
    } else { 
        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
        Key tw_key = KeyFactory.stringToKey(t_key); 
        String tweet_text="", user_name="", date="";
 
        String count = "";
			Entity tweet = ds.get(tw_key);
			 tweet_text = (String) tweet.getProperty("tweet");
			 Long newcount = (Long) tweet.getProperty("count");
			 newcount +=1 ;
			 tweet.setProperty("count", newcount);
			 user_name = (String) tweet.getProperty("user_name");
			 date = (String) tweet.getProperty("date");
			 ds.put(tweet);
			
			

    %>	

<div><span class = "label label-success">Tweet:</span> <a href="">  <%=tweet_text %> </a>  </div><br>
<div><span class = "label label-primary">Posted on:</span> <%=date %> </div><br>
<div><span class = "label label-default">Posted by:</span> <%=user_name %> </div><br>
<div><span class = "label label-info">View Count:</span> <%=newcount %> </div><br>
<hr />
<% } %>
</div>


   </div>
</div>


</div>


</body>
</html>