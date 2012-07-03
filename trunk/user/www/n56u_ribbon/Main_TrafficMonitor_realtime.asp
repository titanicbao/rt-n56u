<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta name="svg.render.forceflash" content="false" />

<title>ASUS Wireless Router <#Web_Title#> - <#menu4_2#> : <#menu4_2_1#></title>

<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script language="JavaScript" type="text/javascript" src="state.js"></script>
<script language="JavaScript" type="text/javascript" src="general.js"></script>
<script language="JavaScript" type="text/javascript" src="popup.js"></script>
<script language="JavaScript" type="text/javascript" src="help.js"></script>
<script language="JavaScript" type="text/javascript" src="tmmenu.js"></script>
<script language="JavaScript" type="text/javascript" src="tmcal.js"></script>
<script language="JavaScript" type="text/javascript" src="/bootstrap/js/network_graph.js"></script>

<script type='text/javascript'>
var $j = jQuery.noConflict();

wan_route_x = '<% nvram_get_x("IPConnection", "wan_route_x"); %>';
wan_nat_x = '<% nvram_get_x("IPConnection", "wan_nat_x"); %>';
wan_proto = '<% nvram_get_x("Layer3Forwarding",  "wan_proto"); %>';
qos_enabled = '<% nvram_get_x("",  "qos_enable"); %>';
preferred_lang = '<% nvram_get_x("",  "preferred_lang"); %>';
chk_hwnat = '<% check_hwnat(); %>';

<% nvram("wan0_ifname,lan_ifname,wl_ifname,wan_proto,web_svg,rstats_colors"); %>

var cprefix = 'bw_r';
var updateInt = 2;
var updateDiv = updateInt;
var updateMaxL = 300;
var updateReTotal = 1;
var prev = [];
var speed_history = [];
var debugTime = 0;
var avgMode = 0;
var wdog = null;
var wdogWarn = null;

var ref = new TomatoRefresh('update.cgi', 'output=netdev', 2);

ref.stop = function() {
	this.timer.start(1000);
}

ref.refresh = function(text) {
	var c, i, h, n, j, k;

	watchdogReset();

	++updating;
	try {
		netdev = null;
		eval(text);

		n = (new Date()).getTime();
		if (this.timeExpect) {
			if (debugTime) E('dtime').innerHTML = (this.timeExpect - n) + ' ' + ((this.timeExpect + 2000) - n);
			this.timeExpect += 2000;
			this.refreshTime = MAX(this.timeExpect - n, 500);
		}
		else {
			this.timeExpect = n + 2000;
		}

		for (i in netdev) {
			c = netdev[i];
			if ((p = prev[i]) != null) {
				h = speed_history[i];

				h.rx.splice(0, 1);
				h.rx.push((c.rx < p.rx) ? (c.rx + (0xFFFFFFFF - p.rx)) : (c.rx - p.rx));

				h.tx.splice(0, 1);
				h.tx.push((c.tx < p.tx) ? (c.tx + (0xFFFFFFFF - p.tx)) : (c.tx - p.tx));
			}
			else if (!speed_history[i]) {
				speed_history[i] = {};
				h = speed_history[i];
				h.rx = [];
				h.tx = [];
				for (j = 300; j > 0; --j) {
					h.rx.push(0);
					h.tx.push(0);
				}
				h.count = 0;
			}
			prev[i] = c;
		}
		loadData();
	}
	catch (ex) {
	}
	--updating;
}

function watchdog()
{
	watchdogReset();
	ref.stop();
	//wdogWarn.style.display = '';
}

function watchdogReset()
{
	if (wdog) clearTimeout(wdog)
	wdog = setTimeout(watchdog, 10000);
}

function initB()
{
	if(qos_enabled=="0" && preferred_lang=="JP"){
		$('QoS_disabledesc').style.display="";
	}else{
		$('QoS_disabledesc').style.display="none";
	}
	
	if(chk_hwnat=="1" && preferred_lang=="JP"){
		$('HWNAT_disabledesc').style.display="";
	}else{
		$('HWNAT_disabledesc').style.display="none";
	}

	speed_history = [];

	initCommon(2, 0, 0, 1);
	wdogWarn = E('warnwd');
	watchdogReset();

	ref.start();
}

function switchPage(page){
	if(page == "1")
		
		return false;
	else if(page == "2")
		location.href = "/Main_TrafficMonitor_last24.asp";
	else
		location.href = "/Main_TrafficMonitor_daily.asp";
}
</script>

<style>
    .table tr th {border-top: 0 none; text-align: center;}
    #tab-area ul {margin-bottom: 0px;}
</style>
</head>

<body onload="show_banner(0); show_menu(4, -1, 0); show_footer(); initB();" >
<div class="container-fluid" style="padding-right: 0px">
    <div class="row-fluid">
        <div class="span2"><center><div id="logo"></div></center></div>
        <div class="span10" >
            <div id="TopBanner"></div>
        </div>
    </div>
</div>

<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0" style="position: relative;"></iframe>

<form method="post" name="form" action="../apply.cgi" >
<input type="hidden" name="current_page" value="Main_TrafficMonitor_realtime.asp">
<input type="hidden" name="next_page" value="Main_TrafficMonitor_realtime.asp">
<input type="hidden" name="next_host" value="">
<input type="hidden" name="sid_list" value="WLANConfig11b;">
<input type="hidden" name="group_id" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_mode" value="">
<input type="hidden" name="first_time" value="">
<input type="hidden" name="action_script" value="">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get_x("LANGUAGE", "preferred_lang"); %>">
<input type="hidden" name="wl_ssid2" value="<% nvram_get_x("WLANConfig11b",  "wl_ssid2"); %>">
<input type="hidden" name="firmver" value="<% nvram_get_x("",  "firmver"); %>">

<div class="container-fluid">
    <div class="row-fluid">
        <div class="span2">
            <!--Sidebar content-->
            <!--=====Beginning of Main Menu=====-->
            <div class="well sidebar-nav side_nav" style="padding: 0px;">
                <ul id="mainMenu" class="clearfix"></ul>
                <ul class="clearfix">
                    <li>
                        <div id="subMenu" class="accordion"></div>
                    </li>
                </ul>
            </div>
        </div>

        <div class="span10">
            <!--Body content-->
            <div class="row-fluid">
                <div class="span12">
                    <div class="box well grad_colour_dark_blue">
                        <h2 class="box_head round_top"><#menu4#></h2>
                        <div class="round_bottom">
                            <div id="tabMenu"></div>
                            <div id='rstats'></div>
                            <div>
                                <div id="QoS_disabledesc" align="left" style="color:#FF3300;"><#TM_Note1#></div>
                                <div id="HWNAT_disabledesc" align="left" style="color:#FF3300;"><#TM_Note2#></div>
                                <div align="right" style="margin: 8px 8px 0px 0px;">
                                   <select onchange="switchPage(this.options[this.selectedIndex].value)" class="top-input">
                                        <option><#switchpage#></option>
                                        <option value="1" selected ><#menu4_2_1#></option>
                                        <option value="2"><#menu4_2_2#></option>
                                        <option value="3"><#menu4_2_3#></option>
                                    </select>
                                </div>

                                <div id="tab-area" style="margin-bottom: 0px; margin: -36px 8px 0px 8px;"></div>

                                <center>
                                <!--========= svg =========-->
                                <div class="span12" style="height: 300px;" id="chart">
                                    <svg width="100%" height="100%" version="1.1"
                                    xmlns="http://www.w3.org/2000/svg"
                                    id="svgraph"
                                    onload="init()">
                                    <rect x="0" y="0" width="100%" height="100%" style="fill:#ffffff" id="background"/>

                                    <g id="hori">
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="25%" x2="100%" y2="25%" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="50%" x2="100%" y2="50%" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="75%" x2="100%" y2="75%" />
                                    </g>

                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick0" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick1" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick2" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick3" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick4" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick5" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick6" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick7" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick8" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick9" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick10" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick11" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick12" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick13" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick14" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick15" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick16" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick17" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick18" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick19" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick20" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick21" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick22" />
                                    <line stroke-width="1" stroke="#AAAAAA" x1="0" y1="0%" x2="0" y2="100%" id="tick23" />

                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h0" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h1" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h2" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h3" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h4" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h5" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h6" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h7" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h8" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h9" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h10" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h11" />
                                    <text font-family="Verdana" fill="#114A8A" font-size="11" x="0" y="98%" class="tickH" id="h12" />

                                    <g id="xpst">
                                    	<text font-family="Verdana" fill="#114A8A" font-size="11" x="10" y="28%" id="xpst0" />
                                    	<text font-family="Verdana" fill="#114A8A" font-size="11" x="10" y="53%" id="xpst1" />
                                    	<text font-family="Verdana" fill="#114A8A" font-size="11" x="10" y="78%" id="xpst2" />
                                    	<text font-family="Verdana" fill="#114A8A" font-size="11" x="10" y="3%" id="xpst3" />
                                    </g>

                                    <polyline id="polyTx" style="stroke-width:1" points="" />
                                    <polyline id="polyRx" style="stroke-width:1" points="" />

                                    <g id="pointGroup">
                                    	<rect fill="#fff" opacity="0.8" x="490" y="0" width="283" height="20" id="pointTextBack" class="back" />
                                    	<text font-family="Verdana" font-size="11" fill="#114A8A" x="99%" y="12" id="pointText" />
                                    </g>

                                    <g id="cross">
                                    	<line stroke-width="1" stroke="#114A8A" x1="0" y1="0" x2="0" y2="0" id="crossX" />
                                    	<line stroke-width="1" stroke="#114A8A" x1="0" y1="0" x2="0" y2="0" id="crossY" />
                                    	<rect fill="#114A8A" opacity="0.8" x="0" y="100" width="0" height="35" id="crossTextBack" class="back" />
                                    	<text font-family="Verdana" font-size="11" fill="#fff" x="0" y="-50" id="crossTime" />
                                    	<text font-family="Verdana" font-size="11" fill="#fff" x="0" y="0" id="crossText" />
                                    </g>

                                    </svg>
                                </div>
                                <!--========= svg =========-->
                                </center>

                                <table width="100%" cellpadding="4" cellspacing="0" class="table">
                                    <tr>
                                        <td colspan="2">
                                            <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                                <tr>
                                                    <th width='8%'><#Network#></th>
                                                    <th width='8%'><#Color#></th>
                                                    <th width='8%' style="text-align: right"><#Current#></th>
                                                    <th width='8%' style="text-align: right"><#Average#></th>
                                                    <th width='8%' style="text-align: right"><#Maximum#></th>
                                                    <th width='8%' style="text-align: right"><#Total#></th>
                                                </tr>
                                                <tr>
                                                    <td width='8%' style="text-align:center; vertical-align: middle;"><#Downlink#></td>
                                                    <td width='10%' style="text-align:center; vertical-align: middle;">
                                                        <div id='rx-sel' class="span12" style="border-radius: 5px;">
                                                            <ul id="navigation-1"><b style='border-bottom: 4px solid; display: none;' id='rx-name'></b>
                                                               <li>
                                                                 <!-- @todo <a title="Color" style="color:#B7E1F7;"><i class="icon icon-chevron-up"></i></a>
                                                                  <ul class="navigation-2">
                                                                     <li><a title="Orange" style="background-color:#FF9000;" onclick="switchColorRX(0)"></a></li>
                                                                     <li><a title="Blue" style="background-color:#003EBA;" onclick="switchColorRX(1)"></a></li>
                                                                     <li><a title="Black" style="background-color:#000000;" onclick="switchColorRX(2)"></a></li>
                                                                     <li><a title="Red" style="background-color:#dd0000;" onclick="switchColorRX(3)"></a></li>
                                                                     <li><a title="Gray" style="background-color:#999999;" onclick="switchColorRX(4)"></a></li>
                                                                     <li><a title="Green" style="background-color:#118811;"onclick="switchColorRX(5)"></a></li>
                                                                  </ul> -->
                                                               </li>
                                                            </ul>
                                                        </div>
                                            		</td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right;font-weight: bold;"><span id='rx-current'></span></td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right" id='rx-avg'></td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right" id='rx-max'></td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right" id='rx-total'></td>
                                                </tr>
                                                <tr>
                                                    <td width='8%' style="text-align:center; vertical-align: middle;"><#Uplink#></td>
                                                    <td width='10%' style="text-align:center; vertical-align: middle;">
                                                        <div id='tx-sel' class="span12" style="border-radius: 5px;">
                                                            <ul id="navigation-1"><b style='border-bottom: 4px solid; display: none;' id='tx-name'></b>
                                                               <li>
                                                                  <!-- @todo <a  title="Color" style="color:#B7E1F7;"><i class="icon icon-chevron-up"></i></a>
                                                                  <ul class="navigation-2">
                                                                     <li><a title="Orange" style="background-color:#FF9000;" onclick="switchColorTX(0)"></a></li>
                                                                     <li><a title="Blue" style="background-color:#003EBA;" onclick="switchColorTX(1)"></a></li>
                                                                     <li><a title="Black" style="background-color:#000000;" onclick="switchColorTX(2)"></a></li>
                                                                     <li><a title="Red" style="background-color:#dd0000;" onclick="switchColorTX(3)"></a></li>
                                                                     <li><a title="Gray" style="background-color:#999999;" onclick="switchColorTX(4)"></a></li>
                                                                     <li><a title="Green" style="background-color:#118811;"onclick="switchColorTX(5)"></a></li>
                                                                  </ul> -->
                                                               </li>
                                                            </ul>
                                                        </div>
                                                    </td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right;font-weight: bold;"><span id='tx-current'></span></td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right" id='tx-avg'></td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right" id='tx-max'></td>
                                                    <td width='15%' align='center' valign='top' style="text-align:right" id='tx-total'></td>
                                                </tr>
                                             </table>
                                        </td>
                                    </tr>
                                </table>

                                <div style="display: none;">
                                    <table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">
                                        <thead>
                                            <tr>
                                                <td colspan="5" id="TriggerList">Display Options</td>
                                            </tr>
                                        </thead>

                                        <div id='bwm-controls'>
                                            <tr>
                                                <th width='50%'><#Traffic_Avg#></th>
                                                <td>
                                                    <a href='javascript:switchAvg(1)' id='avg1'>Off</a>,
                                                    <a href='javascript:switchAvg(2)' id='avg2'>2x</a>,
                                                    <a href='javascript:switchAvg(4)' id='avg4'>4x</a>,
                                                    <a href='javascript:switchAvg(6)' id='avg6'>6x</a>,
                                                    <a href='javascript:switchAvg(8)' id='avg8'>8x</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><#Traffic_Max#></th>
                                                <td>
                                                    <a href='javascript:switchScale(0)' id='scale0'>Uniform</a>,
                                                    <a href='javascript:switchScale(1)' id='scale1'>Per IF</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th><#Traffic_Color#></th>
                                                <td>
                                                        <a href='javascript:switchDraw(0)' id='draw0'>Solid</a>,
                                                        <a href='javascript:switchDraw(1)' id='draw1'>Line</a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th></th>
                                                <td>
                                                        <a href='javascript:switchColor()' id='drawcolor'>-</a><a href='javascript:switchColor(1)' id='drawrev'><#Traffic_Reverse#></a>
                                                </td>
                                            </tr>
                                        </div>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<div id="footer"></div>
</form>
</body>
</html>