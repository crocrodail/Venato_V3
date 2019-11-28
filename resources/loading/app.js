/* Need Help? Join my discord @ discord.gg/yWddFpQ */


// And yes... I know this is __very__ messy. 

/* Uncomment for PLAIN TEXT (also uncomment title in index)  document.getElementById('title').innerHTML = config.text.title;  */
document.getElementById('link').innerHTML = config.text.link;
var audio = `<div data-video=${config.videoID} data-autoplay="1" data-loop="1" id="youtube-audio"> </div>`;
if (config.music === true) { 
 $("body").append(audio);
} 

var toCopy  = document.getElementById( 'to-copy' ),
    btnCopy = document.getElementById( 'copy' );

document.addEventListener("keydown", function(e) {
    if ((window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey)  && e.keyCode == 67) {
      e.preventDefault();
      // Process the event here (such as click on submit button)
      copy();
    }
  }, false);

$(function () {

    var llllll = config.images.forEach(appen)
    function appen(i) {
        document.getElementById("bg").innerHTML= document.getElementById("bg").innerHTML + `<img width="100%"height="100%" src=imgs/${i}>`;
}
    function random(pp) {
        return Math.floor(Math.random() * pp);
    }
    var img = $('div#bg img');
    var len = img.length;
    var current = random(len);
    img.hide();
    img.eq(current).show();

    var x = setInterval(function () {
        img.eq(current).fadeOut(config.transitionInterval, function () {
            current = random(len);
            img.eq(current).fadeIn(config.transitionInterval);
        });
    }, 2 * config.transitionInterval + config.imgInterval);
})

function copy() {
    btnCopy.click();
} 

/* forked from https://cdn.rawgit.com/labnol/files/master/yt.js */
function onYouTubeIframeAPIReady() {
var e = document.getElementById("youtube-audio"), 
t = document.createElement(null); 
e.appendChild(t); var a = document.createElement("div"); 
a.setAttribute("id", "youtube-player"), e.appendChild(a); 
var o = function (e) { 
    t.setAttribute("src", "https://i.imgur.com/" + a) }; 
    e.onclick = function () { r.getPlayerState() === YT.PlayerState.PLAYING || r.getPlayerState() === YT.PlayerState.BUFFERING ? (r.pauseVideo(), o(!1)) : (r.playVideo(), o(!0)) }; var r = new YT.Player("youtube-player", { height: "0", width: "0", videoId: e.dataset.video, playerVars: { autoplay: e.dataset.autoplay, loop: e.dataset.loop }, events: { onReady: function (e) { r.setPlaybackQuality("small"), r.setVolume(config.musicVolume) 
    o(r.getPlayerState() !== YT.PlayerState.CUED) }, 
    onStateChange: function (e) { e.data === YT.PlayerState.ENDED && o(!1) } } }) 
}

// From cfx-keks
var count = 0;
var thisCount = 0;


const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += [data.type][data.order - 1] || '';
    },

    initFunctionInvoking(data) {
        document.querySelector('.yeet').style.left = '0%';
        document.querySelector('.yeet').style.width = ((data.idx / count) * 100) + '%';
    },

    startDataFileEntries(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += "\u{1f358}";
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector('.yeet').style.left = '0%';
        document.querySelector('.yeet').style.width = ((thisCount / count) * 100) + '%';
    },

    onLogLine(data) {
        console.log(data.message);
    }
};

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});


btnCopy.addEventListener( 'click', function(){
    toCopy.select();
    
    if ( document.execCommand( 'copy' ) ) {
        btnCopy.classList.add( 'copied' );
      
        var temp = setInterval( function(){
          btnCopy.classList.remove( 'copied' );
          clearInterval(temp);
        }, 600 );
      
    } else {
      console.info( 'document.execCommand went wrong…' )
    }
    
    return false;
  } );

/////////////////////////////////////////////

var progress = [
    {
        logo : "https://i.ibb.co/0G3KyFB/icons8-passenger-96px.png",
        title : "Ceinture de sécurité",
        est : "",
        status : 3
    },
    {
        logo : "https://i.ibb.co/dp3xMML/icons8-ski-mask-96px.png",
        title : "Menu Gang",
        est : "15/10",
        status : 3
    },
    {
        logo : "https://i.ibb.co/dmfGBDv/icons8-car-service-96px.png",
        title : "Gestion des dégâts des véhicules",
        est : "18/10",
        status : 3
    },
    {
        logo : "https://i.ibb.co/PxrBpGQ/icons8-pills-96px.png",
        title : "Nouveau circuit de drogue !",
        est : "18/10",
        status : 1
    },
    {
        logo : "https://i.ibb.co/LYkBb04/icons8-shirt-96px-1.png",
        title : "Garde robe",
        est : "21/10",
        status : 1
    },
    {
        logo : "https://i.ibb.co/NyDPMnJ/platypus.png",
        title : "Mise en place des VP",
        est : "21/10",
        status : 0
    },
    {
        logo : "https://i.ibb.co/nw0NY3z/icons8-traffic-jam-96px-1.png",
        title : "Concessionnaire auto pour pro",
        est : "23/10",
        status : 0
    },
];

progress.forEach(function(element) {
    const li = document.createElement('li');
    li.innerHTML = getItem(element)
    document.getElementById('progressList').appendChild(li);
});



function getItem(item){
    var itemElmnt = 
        "<div class='collapsible-header'>"+
            "<img src='"+item.logo+"'/>"+
            "<p class='collapsible-title'>"+item.title+"<p class='collapsible-estimation'>";

    if(item.est != ''){
        itemElmnt = itemElmnt + ' Estimé le';
    }

    itemElmnt = itemElmnt + " " + item.est + "</p></p>"+
            "<div class='collapsible-icon'><img src='"+getStatusLogo(item.status)+"' width='30px;'/></div>"+
        "</div>";

    return itemElmnt;
}

function getStatusLogo(status){
    var logo = '';

    switch (status) {
        case 0: //planifié
            logo = 'https://i.ibb.co/b6gZtp0/icons8-calendar-96px.png';
            break;
        case 1: //en cours
            logo = 'https://i.ibb.co/0G7J1P1/icons8-computer-support-96px.png';
            break;
        case 2: //prochain reboot
            logo = 'https://i.ibb.co/f8bFWbj/icons8-restart-96px.png';
            break;
        case 3: // disponible
            logo = 'https://i.ibb.co/PgbD11H/icons8-checked-2-96px.png';
            break;    
        default:
            break;
    }

    return logo;
}