<%-- 
    Document   : index
    Created on : Nov 19, 2010, 2:38:20 PM
    Author     : taha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Shares Brokering Service</title>
        <script>
		
			var name;
		
			function login(){
				name = document.getElementById('name').value;
				var password = document.getElementById('password').value;
				document.getElementById('password').value = '';
				
				var authString = name + ':' + password;
				var encodedAuth = btoa(authString);
				var authHeader = 'Basic ' + encodedAuth;
			
				var ajaxRequest = new XMLHttpRequest();
				ajaxRequest.onreadystatechange = function(){
					if(ajaxRequest.readyState == 4){
						if(ajaxRequest.status == 200){
							token = ajaxRequest.responseText;
							getPersonInfo();
						}
					}			
				};
				ajaxRequest.open('POST', 'http://localhost:8080/auth');
				ajaxRequest.setRequestHeader("authorization", authHeader);
				ajaxRequest.send();
			}
		
			function getPersonInfo(){

				var encodedAuth = btoa(token);
				var authHeader = 'Bearer ' + encodedAuth;
				
				var ajaxRequest = new XMLHttpRequest();
				ajaxRequest.onreadystatechange = function(){
					if(ajaxRequest.readyState == 4){
						if(ajaxRequest.status == 200){
							var person = JSON.parse(ajaxRequest.responseText);
							document.getElementById('birthYear').value = person.birthYear;
							document.getElementById('about').value = person.about;
							
							// hide login, show content
							document.getElementById('login').style.display = 'none';
							document.getElementById('content').style.display = 'block';
						}
					}			
				};
				ajaxRequest.open('GET', 'http://localhost:8080/people/' + name);
				ajaxRequest.setRequestHeader("authorization", authHeader);
				ajaxRequest.send();
			}
			
			function setPersonInfo(){
				var about = document.getElementById('about').value;
				var birthYear = document.getElementById('birthYear').value;
				
				var postData = 'name=' + name;
				postData += '&about=' + encodeURIComponent(about);
				postData += '&birthYear=' + birthYear;
				
				var encodedAuth = btoa(token);
				var authHeader = 'Bearer ' + encodedAuth;
				
				var ajaxRequest = new XMLHttpRequest();
				ajaxRequest.onreadystatechange = function(){
					if(ajaxRequest.readyState == 4){
						if(ajaxRequest.status != 200){
							
							// hide content, show login
							document.getElementById('content').style.display = 'none';
							document.getElementById('login').style.display = 'block';
						}
						
					}			
				};
				ajaxRequest.open('POST', 'http://localhost:8080/people/' + name);
				ajaxRequest.setRequestHeader("authorization", authHeader);
				ajaxRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
				ajaxRequest.send(postData);
			}
		</script>
    </head>
    <body>
        <h1>Shares Brokering</h1>
        <p>Latest share prices</p>

        <div id="content">
            <p>Birth year:</p>
            <input type="text" id="birthYear">
            <p>About:</p>
            <textarea id="about"></textarea>
            <p><button type="button" onclick="setPersonInfo()">Save</button></p>
        </div>
    </body>
</html>
