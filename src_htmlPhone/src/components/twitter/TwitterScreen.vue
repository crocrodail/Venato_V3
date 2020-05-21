<template>
  <div style="width: 326px; height: 743px;" class="phone_app">
    <PhoneTitle :title="currentScreen.title" backgroundColor="white" v-on:back="quit()" />
    <div class="phone_content">
      <component v-bind:is="currentScreen.component" />
    </div>
    <div class="twitter_menu">
       <vs-row
        v-for="(Comp, i) of screen"
        :key="i"
        class="twitter_menu-item"
        :class="{select: i === currentScreenIndex}"
        @click="openMenu(i)"
      >
        <vs-col vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
          <i class="subMenu-icon fa" :class="['fa-' + Comp.icon]" @click.stop="swapMenu(i)"></i>
        </vs-col>
      </vs-row>
    </div>
  </div>
</template>

<script>
import PhoneTitle from "./../PhoneTitle";
import TwitterView from "./TwitterView";
import TwitterPostTweet from "./TwitterPostTweet";
import TwitterAccount from "./TwitterAccount";
import TwitterTopTweet from "./TwitterTopTweet";
import { mapGetters } from "vuex";

export default {
  components: {
    PhoneTitle
  },
  data() {
    return {
      currentScreenIndex: 0
    };
  },
  computed: {
    ...mapGetters(["IntlString", "useMouse"]),
    screen() {
      return [
        {
          title: this.IntlString("APP_TWITTER_VIEW_TWITTER"),
          component: TwitterView,
          icon: "fas fa-home"
        },
        {
          title: this.IntlString("APP_TWITTER_VIEW_TOP_TWEETS"),
          component: TwitterTopTweet,
          icon: "far fa-heart"
        },
        {
          title: this.IntlString("APP_TWITTER_VIEW_TWEETER"),
          component: TwitterPostTweet,
          icon: "far fa-comment"
        },
        {
          title: this.IntlString("APP_TWITTER_VIEW_SETTING"),
          component: TwitterAccount,
          icon: "fas fa-cog"
        }
      ];
    },
    currentScreen() {
      return this.screen[this.currentScreenIndex];
    }
  },
  watch: {},
  methods: {
    onLeft() {
      this.currentScreenIndex = Math.max(0, this.currentScreenIndex - 1);
    },
    onRight() {
      this.currentScreenIndex = Math.min(
        this.screen.length - 1,
        this.currentScreenIndex + 1
      );
    },
    home() {
      this.currentScreenIndex = 0;
    },
    openMenu(index) {
      this.currentScreenIndex = index;
    },
    quit() {
      if (this.currentScreenIndex === 0) {
        this.$router.push({ name: 'menu' });
      } else {
        this.currentScreenIndex = 0;
      }
    }
  },
  created() {
    if (!this.useMouse) {
      this.$bus.$on("keyUpArrowLeft", this.onLeft);
      this.$bus.$on("keyUpArrowRight", this.onRight);
    }
    this.$bus.$on("twitterHome", this.quit);
  },
  mounted() {},
  beforeDestroy() {
    this.$bus.$off("keyUpArrowLeft", this.onLeft);
    this.$bus.$off("keyUpArrowRight", this.onRight);
    this.$bus.$off("twitterHome", this.quit);
  }
};
</script>

<style lang="scss" scoped>
.phone_content {
  height: calc(100% - 68px);
  overflow-y: auto;
  width: 337px;
  background-color: #ffffff;
}
.twitter_menu {
  border-top: 1px solid #ccc;
  height: 68px;
  display: flex;
  width: 100%;
  .twitter_menu-item {
    flex-grow: 1;
    flex-basis: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    color: #959595;
    &.select {
      color: #1da1f2;
    }
    :hover {
      color: #1da1f2;
    }
  }
}
</style>
