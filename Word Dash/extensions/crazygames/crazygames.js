
const __gmext_crazy_games = {
	initialized: false,
	authListener: null,

	execute_callback: function(_callback) {
		const _args = Array.prototype.slice.call(arguments, 1);

		// If this is a function call it normally
		if (typeof _callback === "function") {
			return _callback(null, null, ..._args);
		}

		// If this is not a function, it might be a script (try to get it from runner)
		if (GMS_API.get_function) {
			const _cb = GMS_API.get_function(_callback);
			if (_cb) {
				// Call the function with null self or other
				return _cb(null, null, ..._args);
			}
		}

		// Print some helpful message to the console
		console.log("Callback argument is not a method (scripts are not supported on this GM version)");
	},

	gml_to_js_value: function(_value) {
		const value_type = Object.prototype.toString.call(_value);
		if (value_type === '[object Object]') {
			var obj = {};
			for (const [key, value] of Object.entries(_value)) {
				obj[key.replace("gml", "")] = __gmext_crazy_games.gml_to_js_value(value);
			}
			return JSON.parse(JSON.stringify(obj));
		}
		else if (value_type === '[object Array]') {
			var array = [];
			_value.forEach(function (item, index) {
				array[index] = __gmext_crazy_games.gml_to_js_value(item);
			});
			return array;
		}
		return _value
	},

	js_to_gml_value: function(_value) {
		try{
			const value_type = _value.constructor.name;
			if (value_type == "Object") {
				var struct = {};
				for (const [key, value] of Object.entries(_value)) {
					struct["gml" + key] = __gmext_crazy_games.js_to_gml_value(value);
				}
				return JSON.parse(JSON.stringify(struct));
			}
			else if (value_type == "Array") {
				var array = [];
				_value.forEach(function (item, index) {
					array[index] = __gmext_crazy_games.js_to_gml_value(item);
				});
				return array;
			}
			return _value
		}catch(e)
		{
			return {}
		}
	}
};

/////////////////////////////////////////////////////////////////////////////////////////////////

// Introduction
function crazy_init(callback_success,callback_failed) {
    window.CrazyGames.SDK.init({
        wrapper: {
          engine: 'gamemaker',
          sdkVersion: window.__gamemaker_runtimeVersion
        }
      }).then(() => {__gmext_crazy_games.initialized = true; __gmext_crazy_games.execute_callback(callback_success)}).catch((e) => callback_failed(__gmext_crazy_games.js_to_gml_value(e)));
}

function crazy_get_environment() {
	if(!__gmext_crazy_games.initialized) return;
    return window.CrazyGames.SDK.environment;
}

function crazy_started()
{
	return __gmext_crazy_games.initialized;
}

//Game
function crazy_game_settings() {
	if(!__gmext_crazy_games.initialized) return __gmext_crazy_games.js_to_gml_value({});
	
    return __gmext_crazy_games.js_to_gml_value(window.CrazyGames.SDK.game.settings);
}

function crazy_game_gameplay_start() {
	if(!__gmext_crazy_games.initialized) return;
    window.CrazyGames.SDK.game.gameplayStart();
}

function crazy_game_gameplay_stop() {
	if(!__gmext_crazy_games.initialized) return;
    window.CrazyGames.SDK.game.gameplayStop();
}

function crazy_game_loading_start() {
	if(!__gmext_crazy_games.initialized) return;
    window.CrazyGames.SDK.game.loadingStart();
}

function crazy_game_loading_stop() {
	if(!__gmext_crazy_games.initialized) return;
    window.CrazyGames.SDK.game.loadingStop();
}

function crazy_game_happytime() {
	if(!__gmext_crazy_games.initialized) return;
    window.CrazyGames.SDK.game.happytime();
}

function crazy_game_is_instant_multiplayer() {
	if(!__gmext_crazy_games.initialized) return;
	return window.CrazyGames.SDK.game.isInstantMultiplayer;
}

function crazy_game_invite_link(_json) {
	if(!__gmext_crazy_games.initialized) return;

	const data = JSON.parse(_json);
	return window.CrazyGames.SDK.game.inviteLink(data);
}

function crazy_game_get_invite_param(key) {
	if(!__gmext_crazy_games.initialized) return;
	return window.CrazyGames.SDK.game.getInviteParam(key) ?? undefined;
}

function crazy_game_show_invite_button(_json) {
	if(!__gmext_crazy_games.initialized) return;

	const data = JSON.parse(_json);
	return window.CrazyGames.SDK.game.showInviteButton(data);
}

function crazy_game_hide_invite_button() {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.game.hideInviteButton();
}

//Video ads
function crazy_ad_request_ad(type,callback_started,callback_error,callback_finished){
	if(!__gmext_crazy_games.initialized) return;
	const callbacks = {
		adStarted: callback_started,
		adError: callback_error,
		adFinished: callback_finished
	};

    window.CrazyGames.SDK.ad.requestAd(type,callbacks);
}

function crazy_ad_has_ad_block(callback_success,callback_failed){
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.ad.hasAdblock().then((result) => __gmext_crazy_games.execute_callback(callback_success,result)).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

//Banners
function banner_pos(banner_id,w,h,position)
{
	const banner = document.getElementById(banner_id);

	banner.style.position = "absolute";
	banner.style.zIndex = "1000";

	banner.style.width = w+"px";
	banner.style.height = h+"px";

	// Reset all positioning and transform
	banner.style.top = "";
	banner.style.bottom = "";
	banner.style.left = "";
	banner.style.right = "";
	banner.style.transform = "";

	switch (position) {
		case 0: banner.style.top = "0"; banner.style.left = "0";break;
		case 1: banner.style.top = "0"; banner.style.left = "50%"; banner.style.transform = "translateX(-50%)"; break;
		case 2: banner.style.top = "0"; banner.style.right = "0";break;
		case 10: banner.style.top = "50%"; banner.style.left = "0"; banner.style.transform = "translateY(-50%)"; break;
		case 11: banner.style.top = "50%"; banner.style.left = "50%"; banner.style.transform = "translate(-50%, -50%)";break;
		case 12: banner.style.top = "50%"; banner.style.right = "0"; banner.style.transform = "translateY(-50%)"; break;
		case 20: banner.style.bottom = "0"; banner.style.left = "0"; break;
		case 21: banner.style.bottom = "0"; banner.style.left = "50%"; banner.style.transform = "translateX(-50%)"; break;
		case 22: banner.style.bottom = "0"; banner.style.right = "0"; break;
		default: console.warn("Unknown banner position:", position);
	}	
}

function banner_clear(banner_id)
{
	const banner = document.getElementById(banner_id);
	if(banner_id != null)
	{
		banner.style.position = "absolute";
		banner.style.zIndex = "1000";

		banner.style.width = "0px";
		banner.style.height = "0px";

		// Reset all positioning and transform
		banner.style.top = "";
		banner.style.bottom = "";
		banner.style.left = "";
		banner.style.right = "";
		banner.style.transform = "";	
	}
}

function crazy_banner_request_banner(banner_id,w,h,position,callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
	
	banner_pos("crazy_banner_static_" + banner_id,w,h,position);
	window.CrazyGames.SDK.banner.requestBanner({id: "crazy_banner_static_" + banner_id,width: w,height: h,}).then(() => __gmext_crazy_games.execute_callback(callback_success)).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

function crazy_banner_request_responsive_banner(banner_id,w,h,position,callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
	
	banner_pos("crazy_banner_responsive_" + banner_id,w,h,position);
    window.CrazyGames.SDK.banner.requestResponsiveBanner("crazy_banner_responsive_" + banner_id).then(() => __gmext_crazy_games.execute_callback(callback_success)).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

function crazy_banner_clear_banner(banner_id) {
  banner_clear("crazy_banner_static_" + banner_id);
  
	if(!__gmext_crazy_games.initialized) return;
		window.CrazyGames.SDK.banner.clearBanner("crazy_banner_static_" + banner_id);
}

function crazy_banner_clear_responsive_banner(banner_id) {
	banner_clear("crazy_banner_responsive_" + banner_id);
	
	if(!__gmext_crazy_games.initialized) return;
		window.CrazyGames.SDK.banner.clearBanner("crazy_banner_responsive_" + banner_id);
}

function crazy_banner_clear_all_banners()
{
	for(var i = 0 ; i < 10 ; i++)
	{
		crazy_banner_clear_banner(i);
		crazy_banner_clear_responsive_banner(i);
	}
}

//User
function crazy_user_is_user_account_available() {
	if(!__gmext_crazy_games.initialized) return;
	return window.CrazyGames.SDK.user.isUserAccountAvailable;
}

function crazy_user_get_user(callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.user.getUser().then((user) => __gmext_crazy_games.execute_callback(callback_success,__gmext_crazy_games.js_to_gml_value(user))).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

function crazy_user_get_user_system_info() {
	if(!__gmext_crazy_games.initialized) return;
	return __gmext_crazy_games.js_to_gml_value(window.CrazyGames.SDK.user.systemInfo);
}

function crazy_user_get_user_token(callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.user.getUserToken().then((token) => __gmext_crazy_games.execute_callback(callback_success,token)).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

function crazy_user_show_auth_prompt(callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.user.showAuthPrompt().then((user) => __gmext_crazy_games.execute_callback(callback_success,__gmext_crazy_games.js_to_gml_value(user))).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

function crazy_user_add_auth_listener(callback) {
	if(!__gmext_crazy_games.initialized) return;
	
	if(__gmext_crazy_games.authListener == null)
	{
		__gmext_crazy_games.authListener = callback;
		window.CrazyGames.SDK.user.addAuthListener(__gmext_crazy_games.authListener);
	}
}

function crazy_user_remove_auth_listener() {
	if(!__gmext_crazy_games.initialized) return;
	if(__gmext_crazy_games.authListener != null)
	window.CrazyGames.SDK.user.removeAuthListener(__gmext_crazy_games.authListener);
	__gmext_crazy_games.authListener = null;
}

function crazy_user_show_account_link_prompt(callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
		window.CrazyGames.SDK.user.showAccountLinkPrompt().then((response) => __gmext_crazy_games.execute_callback(callback_success,__gmext_crazy_games.js_to_gml_value(response))).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

///Data
function crazy_data_clear() {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.data.clear();
}

function crazy_data_get_item(key) {
	if(!__gmext_crazy_games.initialized) return;
	return window.CrazyGames.SDK.data.getItem(key) ?? undefined;
}

function crazy_data_set_item(key,value) {
	if(!__gmext_crazy_games.initialized) return;
	let ret = window.CrazyGames.SDK.data.setItem(key,value);
	if(ret == null)
		return "";
	else
		return ret;
}

function crazy_data_remove_item(key) {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.data.removeItem(key);
}

//in-game purchses
function crazy_user_get_xsolla_user_token(callback_success,callback_failed) {
	if(!__gmext_crazy_games.initialized) return;
	window.CrazyGames.SDK.user.getXsollaUserToken().then((token) => __gmext_crazy_games.execute_callback(callback_success,token)).catch((e) => __gmext_crazy_games.execute_callback(callback_failed,__gmext_crazy_games.js_to_gml_value({message:e.message,code:e.code})));
}

function crazy_analytics_track_order(order) {
	if(!__gmext_crazy_games.initialized) return;

	const data = JSON.parse(order);
	return window.CrazyGames.SDK.analytics.trackOrder("xsolla", data);
}

function crazy_xsolla_open_paystation(token, callback, options_json = "{}") {
	if (!__gmext_crazy_games.initialized) return;

	const { sandbox = false, queryParams = {} } = JSON.parse(options_json);

	// Helper: send {type, payload} to GML
	const emit = (type, payload) => {
		if (callback != null) {
			__gmext_crazy_games.execute_callback(
				callback,
				__gmext_crazy_games.js_to_gml_value({ type, payload })
			);
		}
	};

	function initAndOpen() {
		try {
			XPayStationWidget.init({ access_token: token, sandbox, queryParams });

			// Wire up all interesting events to single emitter
			XPayStationWidget.on('init', (e) => emit('init', e));
			XPayStationWidget.on('open', (e) => emit('open', e));
			XPayStationWidget.on('load', (e) => emit('load', e));
			XPayStationWidget.on('close', (e) => emit('close', e));
			XPayStationWidget.on('status', (e) => emit('status', e));
			XPayStationWidget.on('status-invoice', (e) => emit('status-invoice', e));
			XPayStationWidget.on('status-delivering', (e) => emit('status-delivering', e));
			XPayStationWidget.on('status-done', (e) => emit('status-done', e));

			if (XPayStationWidget.onError) {
				XPayStationWidget.onError((err) => emit('error', { message: err?.message, code: err?.code }));
			}

			XPayStationWidget.open(); // call from a user gesture to avoid blockers
		} catch (err) {
			emit('error', { message: String(err && err.message || err) });
		}
	}

	// Load the widget script once
	if (!window.XPayStationWidget) {
		const s = document.createElement('script');
		s.async = true;
		s.src = "https://cdn.xsolla.net/payments-bucket-prod/embed/1.5.2/widget.min.js";
		s.onload = initAndOpen;
		s.onerror = () => emit('error', { message: "Failed to load Xsolla Pay Station widget" });
		document.head.appendChild(s);
	} else {
		initAndOpen();
	}
}

function crazy_xsolla_close_paystation() {
	if (window.XPayStationWidget && XPayStationWidget.close) {
		XPayStationWidget.close();
	}
}
