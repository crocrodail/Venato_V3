<template>
  <div style="width: 334px; height: 742px; background: white" class="phone_app">
    <PhoneTitle :title="channel.channel" backgroundColor="#f8d344" @back="onQuit"/>
    <div class="phone_content">
      <div class="elements" ref="elementsDiv">
          <vs-row class="element" v-for='(elem, key) in channel.messages'
            v-bind:key="elem.id"
            v-bind:class="{ select: key === currentSelect}"
            >
            <vs-col class="message" vs-w="12">
              {{elem.message}}
            </vs-col>
            <vs-col class="time">
              {{getTime(elem.timestamp)}}
            </vs-col>
          </vs-row>
      </div>

      <div class='notes_write'>
          <input type="text" placeholder="..." v-model="message" @keyup.enter.prevent="sendMessage">
          <span class='notes_send' @click="sendMessage">></span>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import PhoneTitle from './../PhoneTitle'
import moment from 'moment';

export default {
  components: { PhoneTitle },
  data () {
    return {
      message: '',
      currentSelect: 0,
      channel: {}
    }
  },
  computed: {
    ...mapGetters(['useMouse']),
  },
  methods: {
    setChannel (channel) {
      this.channel = channel
      this.notesSetChannel(this.channel.id)
    },
    getTime(date){
      moment.locale("fr");
      var now = moment();
      var messageDate = moment(date);

      return now.to(messageDate);
    },
    ...mapActions(['notesSetChannel', 'notesSendMessage']),
    scrollIntoViewIfNeeded () {
      this.$nextTick(() => {
        const $select = this.$el.querySelector('.select')
        if ($select !== null) {
          $select.scrollIntoViewIfNeeded()
        }
      })
    },
    onUp () {
      const c = this.$refs.elementsDiv
      c.scrollTop = c.scrollTop - 120
    },
    onDown () {
      const c = this.$refs.elementsDiv
      c.scrollTop = c.scrollTop + 120
    },
    async onEnter () {
      const rep = await this.$phoneAPI.getReponseText()
      if (rep !== undefined && rep.text !== undefined) {
        const message = rep.text.trim()
        if (message.length !== 0) {
          this.notesSendMessage({
            channel: this.channel,
            message
          })
        }
      }
    },
    sendMessage () {
      const message = this.message.trim()
      if (message.length !== 0) {
        this.notesSendMessage({
          channel: this.channel,
          message
        })
        this.message = ''
      }
    },
    onBack () {
      if (this.useMouse === true && document.activeElement.tagName !== 'BODY') return
      this.onQuit()
    },
    onQuit () {
      this.$router.push({ name: 'notes' })
    },
    formatTime (time) {
      const d = new Date(time)
      return d.toLocaleTimeString()
    }
  },
  async created () {
    if (!this.useMouse) {
      this.$bus.$on('keyUpArrowDown', this.onDown)
      this.$bus.$on('keyUpArrowUp', this.onUp)
      this.$bus.$on('keyUpEnter', this.onEnter)
    } else {
      this.currentSelect = -1
    }
    this.$bus.$on('keyUpBackspace', this.onBack)
    this.channel = await this.$apiService.get("/notes-channels/messages/" + this.$route.params.channel);
  },
  mounted () {
    window.c = this.$refs.elementsDiv
    const c = this.$refs.elementsDiv
    c.scrollTop = c.scrollHeight
  },
  beforeDestroy () {
    this.$bus.$off('keyUpArrowDown', this.onDown)
    this.$bus.$off('keyUpArrowUp', this.onUp)
    this.$bus.$off('keyUpEnter', this.onEnter)
    this.$bus.$off('keyUpBackspace', this.onBack)
  }
}
</script>

<style lang="scss">

.phone_title{
  .title{
    font-size: 18px !important;
  }
}
.elements{
  height: calc(100% - 56px);
  background-image: url("/html/static/img/notes/background.jpg");
  color: white;
  display: flex;
  flex-direction: column;
  padding-bottom: 12px;
  overflow-y: auto;

  .element{
    color: #a6a28c;
    flex: 0 0 auto;
    width: 100%;
    display: flex;
    /* margin: 9px 12px;
    line-height: 18px;
    font-size: 18px;
    padding-bottom: 6px;

    flex-direction: row;
    height: 60px; */

    .message{
      width: 100%;
      font-size: 16px;
      color: black;
      padding: 10px 15px;
    }
    .time{
      padding: 0px 15px;
      font-size: 10px;
      margin-left: 15px;

    }
  }
}




.notes_write{
    height: 56px;
    widows: 100%;
    background: #dae0e6;
    display: flex;
    justify-content: space-around;
    align-items: center;
}
.notes_write input{
     width: 75%;
    margin-left: 6%;
    border: none;
    outline: none;
    font-size: 16px;
    padding: 3px 5px;
    float: left;
    height: 36px;
    background-color: white;
    color: black;
}
.notes_write input::placeholder {
  color: #ccc;
}
.notes_send{
    width: 32px;
    height: 32px;
    float: right;
    border-radius: 50%;
    background-color: #f8d344;
    margin-right: 12px;
    margin-bottom: 2px;
    color: white;
    line-height: 32px;
    text-align: center;
}
.elements::-webkit-scrollbar-track
  {
      box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
      background-color: #a6a28c;
  }
.elements::-webkit-scrollbar
  {
      width: 3px;
      background-color: transparent;
  }
.elements::-webkit-scrollbar-thumb
  {
      background-color: #FFC629;
  }
</style>
