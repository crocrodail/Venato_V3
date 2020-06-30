<template>
  <div :class="getClass" v-if="open">
    <vs-row>
      <vs-col class="content" vs-offset="0" vs-type="flex" vs-w="4">
        <vs-row vs-w="12">
          <vs-col
            vs-type="flex"
            vs-justify="center"
            vs-align="center"
            class="item"
            vs-w="4"
            v-for="item in items"
            :key="item.id"
          >
            <div class="container"
            @click="selectItem(item)">
              <img :src="item.image" />
              {{item.id}}
            </div>
          </vs-col>
        </vs-row>
      </vs-col>
    </vs-row>
    <div class="keys">
      <vs-button :color="color" type="relief">A</vs-button>
      <vs-button :color="color" type="relief">E</vs-button>
    </div>
    <div class="close">
      <vs-button color="#b71c1c" type="relief" @click="close">X</vs-button>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ShopMenu from "./ShopMenu.vue";

export default {
  components: {
    ShopMenu
  },
  data() {
    return {
      open: false,
      class: "tattoo",
      color: "#626262",
      items: []
    };
  },
  computed: {
    // ...mapGetters([
    //   "IntlString"
    // ])
    getClass() {
      return "background " + this.class;
    }
  },
  methods: {
    // ...mapActions(["closePhone", "setMessages"]),
    selectItem(item) {
      console.log("Apply Tattoo");
      $.post(
        "http://shop/"+this.class+"/apply",
        JSON.stringify(item)
      );
    },
    close(){
        console.log("Close Tattoo shop");
       $.post(
        "http://shop/"+this.class+"/close"
      );
    },
    handleMessage(event) {
      if (event.data.event == "open") {
        this.class = event.data.appName;
        this.open = true;
      } else if (event.data.event == "close") {
        this.open = false;
      }
    }
  },
  async created() {
    window.addEventListener('message', this.handleMessage);
    this.items = await this.$apiService.get("/tattoo");
  },
  beforeDestroy() {
    window.removeEventListener('message', this.handleMessage)
  }
};
</script>

<style lang="scss" scoped="true">
.background {
  position: absolute;
  height: 100%;
  width: 100%;
  overflow: hidden;
  &.tattoo {
    background: url("/html/static/img/tattoo_shop.png");
    background-size: contain;
  }
  .content {
    background-color: white;
    -webkit-box-shadow: 0 4px 25px 0 rgba(0, 0, 0, 0.1);
    box-shadow: 0 4px 25px 0 rgba(0, 0, 0, 0.1);
    margin-top: 10%;
    margin-left: 5% !important;
    height: 900px;
    max-height: 900px;
    border-radius: 20px;
    padding: 15px;
    overflow: auto;
    .item {
      padding: 10px;
      .container {
        border-radius: 10px;
        text-align: center;
        &:hover {
          background-color: rgb(211, 211, 211);
        }
        img {
          width: 90%;
        }
      }
    }
  }

  .keys {
    position: absolute;
    bottom: 8%;
    right: 5%;
  }
  .close {
    position: absolute;
    top: 5%;
    right: 5%;
  }

  /* width */
  ::-webkit-scrollbar {
    width: 10px;
  }

  /* Track */
  ::-webkit-scrollbar-track {
    box-shadow: inset 0 0 5px transparent;
    border-radius: 50px;
    margin-top: 20px;
    margin-bottom: 20px;
  }

  /* Handle */
  ::-webkit-scrollbar-thumb {
    background: rgb(99, 99, 99);
    border-radius: 5px;
  }

  /* Handle on hover */
  ::-webkit-scrollbar-thumb:hover {
    background: #242424;
  }
}
</style>
