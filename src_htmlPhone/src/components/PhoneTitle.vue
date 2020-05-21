<template>
  <div class="phone_title_content" :style="style" :class="{'hasInfoBare': showInfoBare}" >
    <InfoBare v-if="showInfoBare" />
    <div class="phone_back">
      <vs-row vs-w="12">
        <vs-col vs-type="flex" vs-justify="start" vs-align="left" vs-w="1">
          <vs-button class="btn-back" icon-pack="FA5" @click.stop="back" radius color="primary" type="flat" icon="fas fa-angle-left"></vs-button>
        </vs-col>
        <vs-col vs-type="flex" vs-justify="start" vs-align="left" vs-w="2">
          <span class="back_text">Retour</span>
        </vs-col>
      </vs-row>
    </div>
    <div class="phone_title">
      <vs-row vs-w="12">
        <vs-col vs-type="flex" vs-justify="start" vs-align="left" vs-w="12">
          <span class="title">{{title}}</span>
       </vs-col>
      </vs-row>
    </div>
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import InfoBare from './InfoBare'

export default {
  components: {
    InfoBare
  },
  computed: {
    ...mapGetters(['themeColorTitle']),
    style () {
      return {
        color: this.color || '#FFF'
      }
    }
  },
  methods: {
    back () {
      this.$emit('back')
    }
  },
  props: {
    title: {
      type: String,
      required: true
    },
    showInfoBare: {
      type: Boolean,
      default: true
    },
    backgroundColor: {
      type: String
    }
  }
}
</script>
<style lang="scss" scoped>
.btn-back{
  z-index: 0;
  &:hover{
    background: transparent !important;
  }
}
</style>
