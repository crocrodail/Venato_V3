<template>
  <div style="width: 334px; height: 742px" class="phone_app">
    <PhoneTitle :title="channel.channel" backgroundColor="#f8d344" @back="onQuit" />
      <div class="elements" ref="elementsDiv">
        <vs-row
          class="element"
          v-for="(elem, key) in channel.messages"
          v-bind:key="elem.id"
          v-bind:class="{ select: key === currentSelect}"
        >
          <vs-col class="message" vs-w="12">{{elem.message}}</vs-col>
          <vs-col class="time">{{getTime(elem.timestamp)}}</vs-col>
        </vs-row>
      </div>

      <div style="width: 306px;" id="sms_write" @contextmenu.prevent="showOptions">
        <input
          type="text"
          v-model="message"
          :placeholder="IntlString('APP_MESSAGE_PLACEHOLDER_ENTER_MESSAGE')"
          v-autofocus
          @keyup.enter.prevent="send"
        />
        <div style="    font-size: 10px;" class="sms_send" @click.stop="send">
          <svg height="24" viewBox="0 0 24 24" width="24" @click.stop="send">
            <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
            <path d="M0 0h24v24H0z" fill="none" />
          </svg>
        </div>
      </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Modal from "@/components/Modal/index.js";
import PhoneTitle from "./../PhoneTitle";
import moment from "moment";

export default {
  components: { PhoneTitle },
  data() {
    return {
      message: "",
      currentSelect: 0,
      channel: {}
    };
  },
  computed: {
    ...mapGetters(["IntlString", "useMouse"])
  },
  methods: {
    setChannel(channel) {
      this.channel = channel;
      this.notesSetChannel(this.channel.id);
    },
    getTime(date) {
      moment.locale("fr");
      var now = moment();
      var messageDate = moment(date);

      return now.to(messageDate);
    },
    ...mapActions(["notesSetChannel", "notesSendMessage"]),
    scrollIntoViewIfNeeded() {
      this.$nextTick(() => {
        const $select = this.$el.querySelector(".select");
        if ($select !== null) {
          $select.scrollIntoViewIfNeeded();
        }
      });
    },
    onUp() {
      if (this.ignoreControls === true) return;
      this.currentSelect =
        this.currentSelect === 0 ? 0 : this.currentSelect - 1;
      this.scrollIntoViewIfNeeded();
    },
    onDown() {
      if (this.ignoreControls === true) return;
      this.currentSelect =
        this.currentSelect === this.channel.messages.length - 1
          ? this.currentSelect
          : this.currentSelect + 1;
      this.scrollIntoViewIfNeeded();
    },
    async onRight() {
      if (this.ignoreControls === true) return;
      this.ignoreControls = true;
      let choix = [
        {
          id: 1,
          title: this.IntlString("APP_DARKTCHAT_NEW_NOTE"),
          icons: "fa-plus",
          color: "dodgerblue"
        },
        {
          id: 2,
          title: this.IntlString("APP_DARKTCHAT_DELETE_NOTE"),
          icons: "fa-minus",
          color: "tomato"
        },
        {
          id: 3,
          title: this.IntlString("APP_DARKTCHAT_CANCEL"),
          icons: "fa-undo"
        }
      ];
      if (this.channel.messages.length === 0) {
        choix.splice(1, 1);
      }
      const rep = await Modal.CreateModal({ choix });
      this.ignoreControls = false;
      switch (rep.id) {
        case 1:
          await this.onEnter();
          break;
        case 2:
          await this.removeMessageOption();
          break;
        case 3:
      }
    },
    async onEnter() {
      if (this.ignoreControls === true) return;
      console.log("onEnter");
      const rep = await this.$phoneAPI.getReponseText();
      if (rep !== undefined && rep.text !== undefined) {
        const message = rep.text.trim();
        if (message.length !== 0) {
          await this.$apiService.post(
            "/notes-channels/messages/" + this.$route.params.channel,
            { message: message }
          );
          await this.init();
        }
      }
    },
    async removeMessageOption() {
      const message = this.channel.messages[this.currentSelect];
      await this.$apiService.delete("/notes-channels/messages/" + message.id);
      await this.init();
    },
    sendMessage() {
      const message = this.message.trim();
      if (message.length !== 0) {
        this.notesSendMessage({
          channel: this.channel,
          message
        });
        this.message = "";
      }
    },
    onBack() {
      if (this.useMouse === true && document.activeElement.tagName !== "BODY")
        return;
      this.onQuit();
    },
    onQuit() {
      this.$router.push({ name: "notes" });
    },
    formatTime(time) {
      const d = new Date(time);
      return d.toLocaleTimeString();
    },
    async init() {
      this.channel = await this.$apiService.get(
        "/notes-channels/messages/" + this.$route.params.channel
      );
    }
  },
  async created() {
    if (!this.useMouse) {
      this.$bus.$on("keyUpArrowDown", this.onDown);
      this.$bus.$on("keyUpArrowUp", this.onUp);
      this.$bus.$on("keyUpEnter", this.onEnter);
      this.$bus.$on("keyUpArrowRight", this.onRight);
    } else {
      this.currentSelect = -1;
    }
    this.$bus.$on("keyUpBackspace", this.onBack);
    await this.init();
  },
  mounted() {
    window.c = this.$refs.elementsDiv;
    const c = this.$refs.elementsDiv;
    c.scrollTop = c.scrollHeight;
  },
  beforeDestroy() {
    this.$bus.$off("keyUpArrowDown", this.onDown);
    this.$bus.$off("keyUpArrowUp", this.onUp);
    this.$bus.$off("keyUpEnter", this.onEnter);
    this.$bus.$off("keyUpBackspace", this.onBack);
    this.$bus.$off("keyUpArrowRight", this.onRight);
  }
};
</script>

<style lang="scss" scoped>
.phone_title {
  .title {
    font-size: 18px !important;
  }
}

.elements {
  height: calc(100% - 56px);
  color: white;
  display: flex;
  flex-direction: column;
  padding-bottom: 12px;
  overflow-y: auto;

  .element {
    color: #a6a28c;
    flex: 0 0 auto;
    width: 100%;
    display: flex;
    padding-bottom: 6px;

    &.select,
    &:hover {
      background: radial-gradient(
        rgba(3, 168, 244, 0.14),
        rgba(3, 169, 244, 0.26)
      );

      .message {
        color:white;
        font-weight: bolder;
      }
      .time {
        color:white;
        font-weight: bold;
      }
    }

    .message {
      width: 100%;
      font-size: 16px;
      color: white;
      padding: 10px 15px;
    }
    .time {
      padding: 0px 15px;
      font-size: 10px;
      margin-left: 15px;
    }
  }
}

.notes_write {
  height: 56px;
  widows: 100%;
  background: #dae0e6;
  display: flex;
  justify-content: space-around;
  align-items: center;
}
.notes_write input {
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
.notes_send {
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
.elements::-webkit-scrollbar-track {
  box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
  background-color: #a6a28c;
}
.elements::-webkit-scrollbar {
  width: 3px;
  background-color: transparent;
}
.elements::-webkit-scrollbar-thumb {
  background-color: #ffc629;
}

#sms_write{
    height: 56px;
    margin: 10px;
    margin-top: -5px;
    width: 380px;

    background-color: #3d3d3d;
    border-radius: 56px;
}
#sms_write input{
    height: 56px;
    border: none;
    outline: none;
    font-size: 16px;
    margin-left: 14px;
    padding: 12px 5px;
    background-color: rgba(236, 236, 241, 0)
}

.sms_send{
    float: right;
    margin-right: 10px;
}
.sms_send svg{
    margin: 8px;
    width: 36px;
    height: 36px;
    fill: #C0C0C0;
}
</style>
