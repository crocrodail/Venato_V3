window.addEventListener("DOMContentLoaded", () =>{
    let questions = []
    console.log(document.querySelectorAll("input[type='radio']"))
    
    document.querySelector(".btn-submit").addEventListener("click", () =>{
        let questionispush = questions.length
        if(questions.length != 10){
            while(questions.length != questionispush+1){
                const randomKey = getRandomInt(20)
                if(!questions.includes(randomKey)){
                    questions.push(randomKey)
                }
            }
        }
        event.preventDefault()
        document.querySelector(".questions").style.display = "block"
        document.querySelector(".consignes").style.display = "none"
        document.querySelector(".btn-submit").innerHTML = "Prochaine question"
        let image = document.querySelector(".imageCode")
        let title = document.querySelector(".title")
        for(const value of questions){
            image.style.backgroundImage = `url(${JSON.parse(localStorage.getItem("questions"))[value]["image"]})`
            title.innerHTML = JSON.parse(localStorage.getItem("questions"))[value]["question"]
            document.querySelector(".un").innerHTML = JSON.parse(localStorage.getItem("questions"))[value]["answer"][0]
            document.querySelector(".deux").innerHTML = JSON.parse(localStorage.getItem("questions"))[value]["answer"][1]
            document.querySelector(".trois").innerHTML = JSON.parse(localStorage.getItem("questions"))[value]["answer"][2]
            document.querySelector(".quatre").innerHTML = JSON.parse(localStorage.getItem("questions"))[value]["answer"][3]
        }
    })
})
function getRandomInt(max) {
    return Math.floor(Math.random() * Math.floor(max));
}
function checkAnswer(){
    
}