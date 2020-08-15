<template>
    <div class="desktop">
      <div class="grid-layout-container margin-right">
        <grid-layout
          :layout="layoutLeft"
          :col-num="nbColumn"
          :colWidth="BASE_LEN"
          :row-height="BASE_LEN"
          :is-draggable="false"
          :is-resizable="false"
          :is-mirrored="false"
          :vertical-compact="true"
          :margin="[0, 0]"
          :use-css-transforms="true"
        >
          <grid-item
            v-for="(item, index) in layoutLeft"
            :x="item.x"
            :y="item.y"
            :w="item.w"
            :h="item.h"
            :i="item.i"
            :key="index"
          >
            <div class="container">
              <MetroTile
                :width="width(item.w)"
                :height="height(item.h)"
                :length="item.length"
                :rotateX="item.rotateX"
                :faceStyle="item.faceStyle"
              >
                <template>
                  <div v-if="item.front" slot="front">
                    <div class="tile-label">{{item.front.title}}</div>
                    <img
                      v-bind:class="{ fill: item.front.fill }"
                      :src="item.front.icon"
                      class="icon"
                    />
                  </div>
                </template>
              </MetroTile>
            </div>
          </grid-item>
        </grid-layout>
      </div>
    </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import MetroTile from "vue-metro-tile";
import VueGridLayout from "vue-grid-layout";

const BASE_LEN = 65;
const MARGIN = 3;
const REPO_URL = "https://github.com/yuanfux/vue-metro-tile";

export default {
  components: {
    MetroTile,
    VueGridLayout
  },
  data() {
    return {
      BASE_LEN,
      nbColumn: 900 / (BASE_LEN + MARGIN) + 1,
      layoutLeft: [
        {
          x: 0,
          y: 0,
          w: 2,
          h: 2,
          i: "0",
          faceStyle: {
            "background-color": "#00897b"
          },
          front: {
            icon: "https://i.ibb.co/HHBwjgZ/icons8-gmail-96px-1.png"
          }
        }, // Mail
        {
          x: 2,
          y: 0,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#e1f5fe"
          },
          front: {
            icon: "https://i.ibb.co/vsGG5GS/icons8-google-96px.png"
          }
        }, // Google
        {
          x: 0,
          y: 1,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#132b67"
          },
          front: {
            icon: "https://i.ibb.co/K9fg4hp/Metro.png",
            fill: true
          }
        }, // Metro
        {
          x: 2,
          y: 1,
          w: 4,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#e8f5e9"
          },
          front: {
            icon: "https://i.ibb.co/tYxDz25/venato-bank.png"
          }
        }, // Bank
        {
          x: 6,
          y: 1,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#1a237e"
          },
          front: {
            icon: "https://i.ibb.co/CMsgRgY/icons8-police-badge-96px.png"
          }
        }, // Police
        {
          x: 8,
          y: 0,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#ffebee"
          },
          front: {
            icon: "https://i.ibb.co/YWkf2xZ/cropped-favicon-crf.png"
          }
        }, // Ambulance
        {
          x: 4,
          y: 0,
          w: 4,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#212121"
          },
          front: {
            icon: "https://i.ibb.co/P6ycm4W/logo.png"
          }
        }, // Concessionnaire
        {
          x: 8,
          y: 1,
          w: 4,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#ffebee"
          },
          front: {
            icon: "https://i.ibb.co/PCPq6xd/logo.png",
            fill: true
          }
        }, // Agence immobiliaire
        {
          x: 10,
          y: 0,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#1C9DEB"
          },
          front: {
            icon: "https://i.ibb.co/NTsHVD3/icons8-twitter-60px-1.png"
          }
        }, // Twitter
        {
          x: 12,
          y: 1,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#212121"
          },
          front: {
            icon: "https://i.ibb.co/FnD3yYX/icons8-shutdown-96px-1.png"
          }
        }, // ShutDown
        {
          x: 12,
          y: 0,
          w: 2,
          h: 2,
          i: "1",
          faceStyle: {
            "background-color": "#0d47a1"
          },
          front: {
            icon: "https://i.ibb.co/NyDPMnJ/venato.png",
            fill: true
          }
        } // Mairie
      ]
    };
  },
  computed: {},
  methods: {
    handleMessage(event) {
      // if (event.data.event == "open") {
      //   this.class = event.data.appName;
      //   this.open = true;
      // } else if (event.data.event == "close") {
      //   this.open = false;
      // }
    },
    width(itemW) {
      return BASE_LEN * itemW - MARGIN * 2;
    },
    height(itemH) {
      return BASE_LEN * itemH - MARGIN * 2;
    },
    // setRotateX(layoutItem, rotateIndexName, rotateArray) {
    //   layoutItem.rotateX +=
    //     rotateArray[this[rotateIndexName] % rotateArray.length];
    //   this[rotateIndexName] += 1;
    // },
    redirect() {
      window.open(REPO_URL, "_blank");
      // window.location.href = REPO_URL;
    }
  },
  created() {
    window.addEventListener("message", this.handleMessage);
  },
  async mounted() {
    // this.interval1 = setInterval(() => {
    //   this.setRotateX(this.layoutLeft[7], "rotateIndex1", this.rotateArray1);
    // }, 3000);
    // this.interval2 = setInterval(() => {
    //   this.setRotateX(this.layoutRight[6], "rotateIndex2", this.rotateArray2);
    // }, 5000);
  },
  beforeDestroy() {
    window.removeEventListener("message", this.handleMessage);
  }
};
</script>
