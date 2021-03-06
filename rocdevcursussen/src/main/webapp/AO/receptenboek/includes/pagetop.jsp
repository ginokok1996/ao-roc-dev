<%@ include file="/includes/top.html" %>
</head>

<body>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%

	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	
	
	if (user == null) { %>
		<h2>Hallo, voor deze site moet je zijn ingelogd</h2>
		<p>Log in met een <a href="<%= userService.createLoginURL("/AO/JSP_Java_DB/Opdrachten.jsp") %>">roc-dev Account</a> voor toegang tot de site</p>
	
	
	<!-- als gebruiker ingelogd is... -->
	
		
	<% } else {
		pageContext.setAttribute("user", user); 
		
	} %>
	

	
	<% if (user != null) { 
		
	
	%>
		
		<!--Titelbalk pagina -->
<div id="header">
  <div class="container">
    <div class="col-md-3">
      <div id="logo"> <a href="/Welkom.jsp"><img id="rocdevlogo"src="/images/roc-dev-googlefont.png"></a> </div>
    </div>
    
    
    <!-- Titel -->
    <div class="col-md-6">
      <div id="heading">
        <h1>Web Apps</h1>
      </div>
    </div>
    
    
    <div class="col-md-3"> 
      <!-- gebruikersnaam en log uit -->
      <p class="loguit">${fn:escapeXml(user.nickname)}: <a href="http://ao.roc-dev.com/_ah/logout?continue=https://www.google.com/accounts/Logout%3Fcontinue%3Dhttps://appengine.google.com/_ah/logout%253Fcontinue%253Dhttp://ao.roc-dev.com/Welkom.jsp%26service%3Dah">afmelden</a></p>
    </div>
  </div>
  
  <!-- Navigatie -->
  <nav class="navbar navbar-inverse navbar-static-top" role="navigation">
    <div class="container">
      <div class="container-fluid"> 
        <!-- Brand and toggle get grouped for better mobile display -->
        
       <!--  Navigatie -->
        
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"> <span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
          <a class="navbar-brand" href="/Welkom.jsp">Home</a> </div>
        
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav">
            <li class="dropdown">
            	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" 
            	aria-haspopup="true" aria-expanded="false">Java <span class="caret"></span></a>
            	<ul class="dropdown-menu">
            		 <li><a href="/AO/InlJava/H1/H1.jsp">Inleiding Java</a></li>
            		 <li><a href="/AO/BlueJ/BlueJ.jsp">BlueJ</a></li>
            	</ul>
			</li>
            <li><a href="/AO/HtmlCss/H1/H1.jsp">HTML/CSS</a></li>
            <li class="dropdown active">
            	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" 
            	aria-haspopup="true" aria-expanded="false">WebApps <span class="caret"></span></a>
            	<ul class="dropdown-menu">
            		 <li><a href="/AO/JSP_Java_DB/Opdrachten.jsp">JSP</a></li>
            		 <li><a href="/AO/PHP/php01.jsp">PHP</a></li>
            		 <li><a href="/jquery">JQuery</a></li>
            	</ul>
			</li>
            <li><a href="/AO/android/H1/H1.jsp">Android</a></li>
           <li><a href="/AO/Examen/Jemeppe.jsp">Examen</a></li> 
          </ul>
        <!-- /.navbar-collapse --> 
      </div>
      <!-- /.container-fluid --> 
    </div>
  </nav>
  
  
  
  
  <div class="container"> 
    <!--Main sectie == alles onder titelbalk -->
    
    <div id="main">
    
      <div class="col-md-3"> 
        <!--Zijmenu -->
        <div id="menu">
          <h3>Inhoud</h3>
			<ul>
				<li>Deel 1 <br>
					<a href="/AO/JSP_Java_DB/Opdrachten.jsp">Werken met JSP</a>
				</li>
				<li>Deel 2 <br>
					<a href="/AO/JSP_Java_DB/Opdrachten_2.jsp">Formulieren</a>
				</li>
				<li>Deel 3 <br>
					<a href="/jsp_deel_3">Java klassen</a><br>
					<a href="/jsp_deel_3#zelftoets">Toets 1e jaar</a></li>
				<li>Deel 4 <br>
					<a href="/sport">Databases</a>
				</li>
				<li>Deel 5<br>
					<a href="/kalender">MVC en Servlets</a>
				</li>
			</ul>
			
			
			<h3>Web Links</h3>
			<ul>
				<li><a href="https://eclipse.org/downloads/packages/eclipse-ide-java-ee-developers/lunasr2" 
					target="_blank">Eclipse</a></li>
				<li><a href="https://developers.google.com/appengine/" target="_blank">App Engine</a></li>
				<li><a href="https://drive.google.com/a/roc-dev.com/file/d/0B3XneerL-ZIcYXlIRWpub3Vqelk/edit?usp=sharing" target="_blank">Opdrachten (doc)</a></li>
				
			</ul>
        </div>
      </div>
      
<% } %>