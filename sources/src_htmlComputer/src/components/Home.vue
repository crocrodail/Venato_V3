<template>
  <div class="desktop">
    <div class="grid-layout-container margin-right">
      <grid-layout
                  :layout="layoutLeft"
                  :col-num="6"
                  :colWidth="BASE_LEN"
                  :row-height="BASE_LEN"
                  :is-draggable="true"
                  :is-resizable="false"
                  :is-mirrored="false"
                  :vertical-compact="true"
                  :margin="[0, 0]"
                  :use-css-transforms="true"
      >
        <grid-item v-for="item in layoutLeft"
                   :x="item.x"
                   :y="item.y"
                   :w="item.w"
                   :h="item.h"
                   :i="item.i"
                   :key="item.i">
          <div class="container">
            <MetroTile
                :width="item.width"
                :height="item.height"
                :length="item.length"
                :rotateX="item.rotateX"
                :faceStyle="item.faceStyle">
              <!-- custom face for each tile in left layout-->
              <template v-if="item.i === '0'">
                <div slot="front">
                    <div class="tile-label">
                      Microsoft Edge
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '1'">
                <div slot="front">
                    <div class="tile-label">
                      Xbox
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '2'">
                <div slot="front">
                    <div class="tile-label">
                      My Office
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '3'">
                <div slot="front">
                    <div class="tile-label">
                      OneNote
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '4'">
                <div slot="front">
                    <div class="tile-label">
                      PowerPoint
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '5'">
                <div slot="front">
                    <div class="tile-label">
                      Cortana
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '6'">
                <div slot="front">
                    <div class="calendar">
                      <div class="calendar-week-day">
                        {{weekDay}}
                      </div>
                      <div class="calendar-month-day">
                        {{monthDay}}
                      </div>
                    </div>
                </div>
              </template>
              <template v-else-if="item.i === '7'">
                <div slot="front">
                    <div class="tile-label">
                      Microsoft Store
                    </div>
                    <img src="https://user-images.githubusercontent.com/6414178/45696034-3fd14280-bb95-11e8-8c45-cd2020fabefc.png" class="store-cover-img" />
                    <div class="store-title">
                      Cyberpunk 2077
                    </div>
                    <div class="store-subtitle">
                        Free&#8314;
                    </div>
                </div>
                <div slot="top">
                    <div class="tile-label">
                      Microsoft Store
                    </div>
                    <img src="https://user-images.githubusercontent.com/6414178/45696084-56779980-bb95-11e8-87ac-817bf448cd4f.png" class="store-cover-img" />
                    <div class="store-title">
                      Half-Life 3: Episode 1
                    </div>
                    <div class="store-subtitle">
                        Free&#8314;
                    </div>
                </div>
                <div slot="bottom">
                    <div class="tile-label">
                      Microsoft Store
                    </div>
                    <img src="https://user-images.githubusercontent.com/6414178/45696072-4eb7f500-bb95-11e8-8e7c-ccb0099e5161.png" class="store-cover-img" />
                    <div class="store-title">
                      Grand Theft Auto VI
                    </div>
                    <div class="store-subtitle">
                        Free&#8314;
                    </div>
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
import MetroTile from 'vue-metro-tile';
import VueGridLayout from 'vue-grid-layout';


const BASE_LEN = 65;
const MARGIN = 3;
const REPO_URL = 'https://github.com/yuanfux/vue-metro-tile';

export default {
  components: {
    MetroTile,
    VueGridLayout
  },
  data() {
    return {
    BASE_LEN,
    layoutLeft: [
      {
        x: 0,
        y: 0,
        w: 4,
        h: 2,
        i: "0",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
       },
      {
        x: 2,
        y: 2,
        w: 4,
        h: 2,
        i: "1",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#228b22'
        }
      },
      {
        x: 0,
        y: 4,
        w: 4,
        h: 2,
        i: "2",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#ff4500'
        }
      },
      {
        x: 4,
        y: 0,
        w: 2,
        h: 2,
        i: "3",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#9400d3'
        }
      },
      {
        x: 4,
        y: 4,
        w: 2,
        h: 2,
        i: "4",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#ffa07a'
        }
      },
      {
        x: 0,
        y: 2,
        w: 2,
        h: 2,
        i: "5",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      },
      {
        x: 0,
        y: 6,
        w: 2,
        h: 2,
        i: "6",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      },
      {
        x: 2,
        y: 6,
        w: 4,
        h: 2,
        i: "7",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      }
    ],
    layoutRight: [
      {
        x: 0,
        y: 0,
        w: 1,
        h: 1,
        i: "0",
        width: BASE_LEN - MARGIN*2,
        height: BASE_LEN - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      },
      {
        x: 1,
        y: 0,
        w: 1,
        h: 1,
        i: "1",
        width: BASE_LEN - MARGIN*2,
        height: BASE_LEN - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      },
      {
        x: 1,
        y: 1,
        w: 1,
        h: 1,
        i: "2",
        width: BASE_LEN - MARGIN*2,
        height: BASE_LEN - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      },
      {
        x: 0,
        y: 1,
        w: 1,
        h: 1,
        i: "3",
        width: BASE_LEN - MARGIN*2,
        height: BASE_LEN - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#1E90FF'
        }
      },
      {
        x: 2,
        y: 0,
        w: 4,
        h: 2,
        i: "4",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#3cb371'
        }
      },
      {
        x: 0,
        y: 2,
        w: 4,
        h: 4,
        i: "5",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*4 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#000'
        }
      },
      {
        x: 4,
        y: 2,
        w: 2,
        h: 2,
        i: "6",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        frontStyle: {
          'background-color': '#8a2be2'
        },
        topStyle: {
          'background-color': '#1E90FF'
        },
        backStyle: {
          'background-color': 'yellow'
        },
        bottomStyle: {
          'background-color': 'green'
        },
        perspective: 0
      },
      {
        x: 4,
        y: 4,
        w: 2,
        h: 2,
        i: "7",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#4169e1'
        }
      },
      {
        x: 0,
        y: 6,
        w: 4,
        h: 2,
        i: "8",
        width: BASE_LEN*4 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#4169e1'
        }
      },
      {
        x: 4,
        y: 6,
        w: 2,
        h: 2,
        i: "9",
        width: BASE_LEN*2 - MARGIN*2,
        height: BASE_LEN*2 - MARGIN*2,
        rotateX: 0,
        faceStyle: {
          'background-color': '#cd5c5c'
        }
      }
    ],
    weekDay: (() => {
      const weekDayMap = {
        0: 'Sunday',
        1: 'Monday',
        2: 'Tuesday',
        3: 'Wednesday',
        4: 'Thursday',
        5: 'Friday',
        6: 'Saturday'
      }
      return weekDayMap[new Date().getDay()];
    })(),
    monthDay: (() => {
      return new Date().getDate();
    })(),
    rotateIndex1: 0,
    rotateArray1: [-90, 90, 90, -90],
    rotateIndex2: 0,
    rotateArray2: [-90, 90],
  }
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
    setRotateX(layoutItem, rotateIndexName, rotateArray) {
      layoutItem.rotateX += rotateArray[this[rotateIndexName] % rotateArray.length];
      this[rotateIndexName] += 1;
    },
    redirect() {
      window.open(REPO_URL, '_blank');
      // window.location.href = REPO_URL;
    }
  },
  created() {
    window.addEventListener("message", this.handleMessage);
  },
  async mounted() {
    this.interval1 = setInterval(
      () => {
        this.setRotateX(this.layoutLeft[7], 'rotateIndex1', this.rotateArray1);
      }, 3000);
    this.interval2 = setInterval(
      () => {
        this.setRotateX(this.layoutRight[6], 'rotateIndex2', this.rotateArray2);
      }, 5000);
  },
  beforeDestroy() {
    window.removeEventListener("message", this.handleMessage);
    clearInterval(this.interval1);
    clearInterval(this.interval2);
  }
};
</script>
