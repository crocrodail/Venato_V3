local questions = {
    {
        image = "./assets/img/1.jpg",
        question = "Dans cette situation, le feu est vert :",
        answer = {
            "Je m'arrête devant le feu tricolore", 
            "Je passe car le feu tricolore est vert", 
            "Je change d'itinéraire", 
            "J'appel les mécanos car le feu est en panne"
        }
    },
    {
        image = "./assets/img/2.jpg",
        question = "Dans cette situation, le piéton traverse alors que le feu est vert",
        answer = {
            "J'appel la LSPD, il est en infraction", 
            "J'accélère pour lui faire peur et je freine au dernier moment !", 
            "Je change d'itinéraire", 
            "Je m'arrête"
        }
    },
    {
        image = "./assets/img/3.jpg",
        question = "Dans cette situation, je double le véhicule à ma droite",
        answer = {
            "Je me rabat tout de suite ", 
            "Je n'ai pas le droit, je suis en infraction", 
            "Je me rabat dans quelques secondes", 
            "Je dépasse la vitesse maximale autorisée"
        }
    },
    {
        image = "./assets/img/4.jpg",
        question = "Dans cette situation, je veux tourner à droite",
        answer = {
            "J'attend que le feu rouge soit vert, puis je m'engage", 
            "Je peux m'engager en faisant attention", 
            "Je change d'avis et tourne directement à gauche", 
            "Dans cette voie, je peux continuer tout droit"
        }
    },
    {
        image = "./assets/img/5.jpg",
        question = "Dans cette situation, un homme est a terre suite à un grave accident",
        answer = {
            "Je continue ma route, c'est pas mon problème", 
            "Je sécurise les lieux, appel les EMS et je reste sur les lieux jusqu'à leurs arrivés", 
            "J'appel la LSPD", 
            "Je prend un selfie et le poste sur les réseaux sociaux"
        }
    },
    {
        image = "./assets/img/6.jpg",
        question = "Dans cette situation, je rentre dans une propriété privée",
        answer = {
            "Je peux stationner sans aucun soucis", 
            "Je fais demi-tour, je n'ai pas le droit d'être là", 
            "Je peux stationner en mettant un mot avec mon numéro de téléphone sur le par-brise", 
            "Je peux m'arrêter quelques minutes pour faire pipi"
        }
    },
    {
        image = "./assets/img/7.jpg",
        question = "Dans cette situation, la police me fait signe de m'arrêter sur le côté",
        answer = {
            "J'augmente le son de ma radio", 
            "J'execute la demande des forces de l'ordre", 
            "J'accélère", 
            "Je fais comme ci je n'avais rien entendu"
        }
    },
    {
        image = "./assets/img/8.jpg",
        question = "Dans cette situation, le feu tricolore est orange",
        answer = {
            "Il est préférable de s'arrêter", 
            "J'accelère et passe à toute vitesse avant que le feu ne passe au rouge", 
            "Je klaxonne", 
            "J'appel le gouvernement pour enlever les feux orange"
        }
    },
    {
        image = "./assets/img/9.jpg",
        question = "Dans cette situation, je suis face a un panneau stop",
        answer = {
            "Comme le panneau le dit, je STOP mon véhicule", 
            "Il est beau le panneau, je peux continuer", 
            "J'accélère", 
            "Je stationne face a la ligne blanche"
        }
    },
    {
        image = "./assets/img/10.jpg",
        question = "Dans cette situation, je regarde mon GPS en circulation",
        answer = {
            "La situation ne présente absolument aucun danger", 
            "Je peux configurer mon itinéraire tranquillement", 
            "La situation présente de grands dangers", 
            "J'allume une cigarette"
        }
    },
    {
        image = "./assets/img/11.jpg",
        question = "Dans cette situation :",
        answer = {
            "J'accélère", 
            "Je klaxonne", 
            "Je circule au pas", 
            "Je peux stationner ici"
        }
    },
    {
        image = "./assets/img/12.jpg",
        question = "Dans cette situation :",
        answer = {
            "Je peux doubler par la droite", 
            "Je klaxonne", 
            "Je peux doubler par la gauche", 
            "Je freine brusquement"
        }
    },
    {
        image = "./assets/img/13.jpg",
        question = "Dans cette situation, je veux acheter des fruits à l'épicier",
        answer = {
            "Je m'arrête au milieu de la route pendant quelques secondes", 
            "Je fais demi-tour, je n'ai pas le droit d'être là", 
            "Je m'arrête un peu plus loins à droite", 
            "Je reste dans la voiture et passe commande en drive"
        }
    },
    {
        image = "./assets/img/14.jpg",
        question = "Dans cette situation, je veux faire mes courses",
        answer = {
            "Je peux stationner ici sans aucun soucis", 
            "Je recule et stationne sur les emplacements indiqués", 
            "Je klaxonne pour que l'épicier vienne me servir", 
            "Je peux m'arrêter ici quelques instants pour montrer ma belle voiture à la dame à gauche"
        }
    },
    {
        image = "./assets/img/15.jpg",
        question = "Dans cette situation :",
        answer = {
            "Je suis bien placer pour circuler", 
            "Cette zone est reservé aux piétons", 
            "Je ne prend aucun risque", 
            "Je peux stationner ici"
        }
    },
    {
        image = "./assets/img/16.jpg",
        question = "Dans cette situation, en deux roues",
        answer = {
            "Je peux doubler par la droite", 
            "Je peux doubler par la voie la plus à gauche", 
            "Je peux serer les voitures sans aucun risques", 
            "Je suis moins vulnérable qu'en voiture"
        }
    },
    {
        image = "./assets/img/17.jpg",
        question = "Dans cette situation :",
        answer = {
            "Je fonce dans la voiture pour aller plus vite", 
            "Je klaxonne", 
            "Je fais demi-tour", 
            "Je double par la gauche et continue ma route"
        }
    },
    {
        image = "./assets/img/18.jpg",
        question = "Dans cette situation :",
        answer = {
            "Je peux stationner sans aucun soucis", 
            "Je stationne comme ceci pour eviter de me faire rayer mon véhicule", 
            "Je refais une main-oeuvre et me gare en bataille", 
            "Je coupe le moteur et laisse mon véhicule"
        }
    },
    {
        image = "./assets/img/19.jpg",
        question = "Dans cette situation ce panneau m'indique :",
        answer = {
            "Une interdiction de faire demi-tour", 
            "Une obligation de faire demi-tour", 
            "Une obligation de rouler au pas", 
            "Une interdiction de s'arrêter quelques minutes"
        }
    },
    {
        image = "./assets/img/20.jpg",
        question = "Dans cette situation, je veux aller au concessionnaire",
        answer = {
            "Je passe avant la voiture", 
            "Je passe après la voiture", 
            "Je passe avant la voiture mais en marche arrière", 
            "Je gare mon véhicule ici et continu à pieds"
        }
    },
}


