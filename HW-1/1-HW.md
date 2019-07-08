<!DOCTYPE html>
<html>
<head data-suburl="">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	
		<meta name="author" content="Gogs" />
		<meta name="description" content="Gogs is a painless self-hosted Git service" />
		<meta name="keywords" content="go, git, self-hosted, gogs">
	
	<meta name="referrer" content="no-referrer" />
	<meta name="_csrf" content="bkSKP8_b9T6WSO2z58ZG7PoX3Ag6MTU2MjU4Mzk5NjM3NDE1MzM3Mw==" />
	<meta name="_suburl" content="" />
	
	
	
		<meta property="og:url" content="https://ghostogether.club:443/" />
		<meta property="og:type" content="website" />
		<meta property="og:title" content="GHOST">
		<meta property="og:description" content="Gogs is a painless self-hosted Git service.">
		<meta property="og:image" content="https://ghostogether.club:443/img/gogs-lg.png" />
		<meta property="og:site_name" content="Gogs">
	

	<link rel="shortcut icon" href="/img/favicon.png" />

	<script src="/js/jquery-1.11.3.min.js"></script>
	<script src="/js/libs/jquery.are-you-sure.js"></script>
	<link rel="stylesheet" href="/assets/font-awesome-4.6.3/css/font-awesome.min.css">
	<link rel="stylesheet" href="/assets/octicons-4.3.0/octicons.min.css">

	
	

	

	
	<link rel="stylesheet" href="/css/semantic-2.3.1.min.css">
	<link rel="stylesheet" href="/css/gogs.css?v=eff1323d21c70818265c452cd447d827">
	<noscript>
		<style>
			.dropdown:hover > .menu { display: block; }
			.ui.secondary.menu .dropdown.item > .menu { margin-top: 0; }
		 </style>
	</noscript>

	
	<script src="/js/semantic-2.3.1.min.js"></script>
	<script src="/js/gogs.js?v=eff1323d21c70818265c452cd447d827"></script>

	<title>Sign In - GHOST</title>

	<meta name="theme-color" content="#ff5343">

	
</head>
<body>
	<div class="full height">
		<noscript>This website works better with JavaScript</noscript>

		
			<div class="following bar light">
				<div class="ui container">
					<div class="ui grid">
						<div class="column">
							<div class="ui top secondary menu">
								<a class="item brand" href="/">
									<img class="ui mini image" src="/img/favicon.png">
								</a>

								
									<a class="item" href="/">Home</a>
								

								<a class="item" href="/explore/repos">Explore</a>
								

								

									<a class="item" target="_blank" rel="noopener noreferrer" href="https://gogs.io/docs" rel="noreferrer">Help</a>
									<div class="right menu">
										
										<a class="item" href="/user/login?redirect_to=%2fuser%2flogin">
											<i class="octicon octicon-sign-in"></i> Sign In
										</a>
									</div>

								
							</div>
						</div>
					</div>
				</div>
			</div>
		


<div class="user signin">
	<div class="ui middle very relaxed page grid">
		<div class="column">
			<form class="ui form" action="/user/login" method="post">
				<input type="hidden" name="_csrf" value="bkSKP8_b9T6WSO2z58ZG7PoX3Ag6MTU2MjU4Mzk5NjM3NDE1MzM3Mw==">
				<h3 class="ui top attached header">
					Sign In
				</h3>
				<div class="ui attached segment">
					




					<div class="required inline field ">
						<label for="user_name">Username or email</label>
						<input id="user_name" name="user_name" value="" autofocus required>
					</div>
					<div class="required inline field ">
						<label for="password">Password</label>
						<input id="password" name="password" type="password" autocomplete="off" value="" required>
					</div>
					
					<div class="inline field">
						<label></label>
						<div class="ui checkbox">
							<label>Remember Me</label>
							<input name="remember" type="checkbox">
						</div>
					</div>

					<div class="inline field">
						<label></label>
						<button class="ui green button">Sign In</button>
						<a href="/user/forget_password">Forgot password?</a>
					</div>
					
				</div>
			</form>
		</div>
	</div>
</div>

	</div>
	<footer>
		<div class="ui container">
			<div class="ui left">
				© 2018 Gogs Version: 0.11.79.1211 Page: <strong>0ms</strong> Template: <strong>0ms</strong>
			</div>
			<div class="ui right links">
				
				<div class="ui language bottom floating slide up dropdown link item">
					<i class="world icon"></i>
					<div class="text">English</div>
					<div class="menu">
						
							<a class="item active selected" href="#">English</a>
						
							<a class="item " href="/user/login?lang=zh-CN">简体中文</a>
						
							<a class="item " href="/user/login?lang=zh-HK">繁體中文（香港）</a>
						
							<a class="item " href="/user/login?lang=zh-TW">繁體中文（臺灣）</a>
						
							<a class="item " href="/user/login?lang=de-DE">Deutsch</a>
						
							<a class="item " href="/user/login?lang=fr-FR">français</a>
						
							<a class="item " href="/user/login?lang=nl-NL">Nederlands</a>
						
							<a class="item " href="/user/login?lang=lv-LV">latviešu</a>
						
							<a class="item " href="/user/login?lang=ru-RU">русский</a>
						
							<a class="item " href="/user/login?lang=ja-JP">日本語</a>
						
							<a class="item " href="/user/login?lang=es-ES">español</a>
						
							<a class="item " href="/user/login?lang=pt-BR">português do Brasil</a>
						
							<a class="item " href="/user/login?lang=pl-PL">polski</a>
						
							<a class="item " href="/user/login?lang=bg-BG">български</a>
						
							<a class="item " href="/user/login?lang=it-IT">italiano</a>
						
							<a class="item " href="/user/login?lang=fi-FI">suomi</a>
						
							<a class="item " href="/user/login?lang=tr-TR">Türkçe</a>
						
							<a class="item " href="/user/login?lang=cs-CZ">čeština</a>
						
							<a class="item " href="/user/login?lang=sr-SP">српски</a>
						
							<a class="item " href="/user/login?lang=sv-SE">svenska</a>
						
							<a class="item " href="/user/login?lang=ko-KR">한국어</a>
						
							<a class="item " href="/user/login?lang=gl-ES">galego</a>
						
							<a class="item " href="/user/login?lang=uk-UA">українська</a>
						
							<a class="item " href="/user/login?lang=en-GB">English (United Kingdom)</a>
						
							<a class="item " href="/user/login?lang=hu-HU">Magyar</a>
						
							<a class="item " href="/user/login?lang=sk-SK">Slovenčina</a>
						
							<a class="item " href="/user/login?lang=id-ID">Indonesian</a>
						
							<a class="item " href="/user/login?lang=fa-IR">Persian</a>
						
							<a class="item " href="/user/login?lang=vi-VN">Vietnamese</a>
						
					</div>
				</div>
				<a href="/assets/librejs/librejs.html" style="display:none" data-jslicense="1">Javascript Licenses</a>
				<a target="_blank" rel="noopener noreferrer" href="https://gogs.io">Website</a>
				<span class="version">Go1.10.2</span>
			</div>
		</div>
	</footer>
</body>







<script src="/js/libs/emojify-1.1.0.min.js"></script>
<script src="/js/libs/clipboard-1.5.9.min.js"></script>


</html>

