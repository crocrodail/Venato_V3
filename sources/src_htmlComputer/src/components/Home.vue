<template>

</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    ShopMenu
  },
  data() {
    return {
      open: false,
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
      this.items.forEach(i => {
        i.active = i.id == item.id;
      });

      $.post("http://shop/" + this.class + "/apply", JSON.stringify(item));
    },
    close() {
      $.post("http://shop/" + this.class + "/close");
    },
    handleMessage(event) {
      if (event.data.event == "open") {
        this.class = event.data.appName;
        this.open = true;
      } else if (event.data.event == "close") {
        this.open = false;
      }
    },
    async refreshList() {
      this.items = (await this.$apiService.get("/"+this.class)).map(t => {
        return {...t, active: false };
      });
    }
  },
  watch: {
    open: async function(value) {
      if(value){
        await this.refreshList();
      }
    }
  },
  created() {
    window.addEventListener("message", this.handleMessage);
  },
  async mounted(){
    await this.refreshList();
  },
  beforeDestroy() {
    window.removeEventListener("message", this.handleMessage);
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
    background-size: cover;
    background-repeat: no-repeat;
  }
  .content {
    background-color: white;
    -webkit-box-shadow: 0 4px 25px 0 rgba(0, 0, 0, 0.1);
    box-shadow: 0 4px 25px 0 rgba(0, 0, 0, 0.1);
    margin-top: 10%;
    margin-left: 5% !important;
    height: 70vh;
    max-height: 70vh;
    border-radius: 20px;
    padding: 15px;
    overflow: auto;
    .item {
      padding: 10px;
      .container {
        position: relative;
        border-radius: 10px;
        text-align: center;
        width: 100%;
        height: 100%;
        &.active {
          border: 2px rgba(0, 0, 0, 0.3) solid;
        }
        &:hover {
          background-color: rgb(211, 211, 211);
        }
        img {
          width: 90%;
        }
        .id{
          position: absolute;
          top: 10px;
          left: 10px;
          font-weight: bolder;
        }
        .active{
          position: absolute;
          top: 10px;
          right: 10px;
        }
        .price{
          bottom: -10px;
          width: 100%;
          text-align: center;
          font-weight: bolder;
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
