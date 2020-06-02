<template>
  <div style="width: 334px; height: 742px; color: white" class="phone_app">
    <PhoneTitle
      :title="IntlString('APP_NOTES')"
      backgroundColor="#f8d344"
      color="white"
      @back="onBack"
    />
    <div class="channels">
      <vs-row
        v-for="(elem, key) in channels"
        v-bind:key="key"
        v-bind:class="{ select: key === currentSelect}"
        class="channel"
      >
        <vs-col vs-w="12">
          <p class="title">{{elem.channel}}</p>
        </vs-col>
        <vs-col vs-w="12">
          <p class="messages">{{elem.messages.length}} message(s)</p>
        </vs-col>
      </vs-row>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Modal from "@/components/Modal/index.js";
import PhoneTitle from "./../PhoneTitle";

export default {
  components: { PhoneTitle },
  data: function() {
    return {
      currentSelect: 0,
      ignoreControls: false,
      channels: []
    };
  },
  watch: {
    list: function() {
      this.currentSelect = 0;
    }
  },
  computed: {
    ...mapGetters(["IntlString", "userId", "useMouse", "Apps"])
  },
  methods: {
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
        this.currentSelect === this.channels.length - 1
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
      if (this.channels.length === 0) {
        choix.splice(1, 1);
      }
      const rep = await Modal.CreateModal({ choix });
      this.ignoreControls = false;
      switch (rep.id) {
        case 1:
          this.addChannelOption();
          break;
        case 2:
          this.removeChannelOption();
          break;
        case 3:
      }
    },
    async onEnter() {
      if (this.ignoreControls === true) return;
      if (this.channels.length === 0) {
        this.ignoreControls = true;
        let choix = [
          {
            id: 1,
            title: this.IntlString("APP_DARKTCHAT_NEW_CHANNEL"),
            icons: "fa-plus",
            color: "green"
          },
          {
            id: 3,
            title: this.IntlString("APP_DARKTCHAT_CANCEL"),
            icons: "fa-undo"
          }
        ];
        const rep = await Modal.CreateModal({ choix });
        this.ignoreControls = false;
        if (rep.id === 1) {
          this.addChannelOption();
        }
      } else {
        this.showChannel(this.channels[this.currentSelect]);
      }
    },
    showChannel(channel) {
      this.$router.push({
        name: "notes.channel.show",
        params: { channel: channel.id }
      });
    },
    onBack() {
      if (this.ignoreControls === true) return;
      this.$router.push({ name: "menu" });
    },
    async addChannelOption() {
      try {
        const rep = await Modal.CreateTextModal({
          limit: 280,
          title: this.IntlString("APP_DARKTCHAT_NEW_CHANNEL")
        });
        let channel = (rep || {}).text || "";
        if (channel.length > 0) {
          this.currentSelect = 0;
          var userId = this.userId ? this.userId : 2336;
          await this.$apiService.post("notes-channels/" + userId, {
            channel: channel
          });
          await this.init();
        }
      } catch (e) {}
    },
    async removeChannelOption() {
      const channel = this.channels[this.currentSelect];
      this.currentSelect = 0;
      await this.$apiService.delete("notes-channels/" + channel.id);
      await this.init();
    },
    async init() {
      var userId = this.userId ? this.userId : 2336;
      this.channels = await this.$apiService.get("notes-channels/" + userId);

    }
  },
  created() {
    if (!this.useMouse) {
      this.$bus.$on("keyUpArrowDown", this.onDown);
      this.$bus.$on("keyUpArrowUp", this.onUp);
      this.$bus.$on("keyUpArrowRight", this.onRight);
      this.$bus.$on("keyUpEnter", this.onEnter);
      this.$bus.$on("keyUpBackspace", this.onBack);
    } else {
      this.currentSelect = -1;
    }
  },
  async mounted() {
    this.init();
  },
  beforeDestroy() {
    this.$bus.$off("keyUpArrowDown", this.onDown);
    this.$bus.$off("keyUpArrowUp", this.onUp);
    this.$bus.$off("keyUpArrowRight", this.onRight);
    this.$bus.$off("keyUpEnter", this.onEnter);
    this.$bus.$off("keyUpBackspace", this.onBack);
  }
};
</script>

<style lang="scss" scoped>
.channels {
  height: calc(100%);
  overflow-y: auto;
  background-color: #000000;
  color: #34302f;
  .channel {
    padding: 10px 15px;
    color:white;
    &.select,
    &:hover {
      background: radial-gradient(
        rgba(3, 168, 244, 0.14),
        rgba(3, 169, 244, 0.26)
      );
    }
    .title {
      font-weight: bolder;
    }
    .messages {
      font-weight: lighter;
    }
  }
}
</style>
