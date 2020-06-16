<template>
  <div class="phone_app">
    <PhoneTitle title="9GAG" @back="quit"/>
    <div class='phone_content' @click="onClick">
      <vs-row class="post" v-if="currentPost !== undefined">
         <vs-col vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
        <span class="post-title">{{ currentPost.title }}</span>
         </vs-col>
        <vs-col class="post-content"  vs-type="flex" vs-justify="center" vs-align="start" vs-w="12">
          <video class="post-video" ref="video" v-if="currentPost.images.image460svwm !== undefined" autoplay loop :src="currentPost.images.image460svwm.url">
          </video>
          <img class="post-image" v-else :src="currentPost.images.image460.url" alt="">
        </vs-col>
      </vs-row>
      <div v-else class="loading">
        <vs-row>
          <vs-col vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
            <img width="200px" src="html/static/img/icons_app/9gag.png">
          </vs-col>
          <vs-col vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
            <i class="fas fa-spinner fa-pulse fa-3x"></i>
          </vs-col>
        </vs-row>
      </div>
    </div>
  </div>
</template>

<script>
import PhoneTitle from './../PhoneTitle'
export default {
  components: {
    PhoneTitle
  },
  data () {
    return {
      nextCursor: 'c=10',
      currentSelectPost: 0,
      posts: [],
    }
  },
  computed: {
    currentPost () {
      if (this.posts && this.posts.length > this.currentSelectPost) {
        return this.posts[this.currentSelectPost]
      }
      this.loadItems()
      return undefined
    }
  },
  methods: {
    async loadItems () {
      let url = 'https://9gag.com/v1/group-posts/group/default/type/hot?' + this.nextCursor
      const request = await fetch(url)
      const data = await request.json()
      this.posts.push(...data.data.posts)
      this.nextCursor = data.data.nextCursor
    },
    previewPost () {
      if (this.currentSelectPost === 0) {
        return 0
      }
      this.currentSelectPost -= 1
      setTimeout(() => {
        if (this.$refs.video !== undefined) {
          this.$refs.video.volume = 0.15
        }
      }, 200)
    },
    nextPost () {
      this.currentSelectPost += 1
      setTimeout(() => {
        if (this.$refs.video !== undefined) {
          this.$refs.video.volume = 0.15
        }
      }, 200)
    },
    onClick ($event) {
      if ($event.offsetX < 200) {
        this.previewPost()
      } else {
        this.nextPost()
      }
    },
    quit: function () {
      this.$router.push({ name: 'menu' })
    }
  },
  created: function () {
    this.$bus.$on('keyUpArrowLeft', this.previewPost)
    this.$bus.$on('keyUpArrowRight', this.nextPost)
    this.$bus.$on('keyUpBackspace', this.quit)
  },
  beforeDestroy: function () {
    this.$bus.$off('keyUpArrowLeft', this.previewPost)
    this.$bus.$off('keyUpArrowRight', this.nextPost)
    this.$bus.$off('keyUpBackspace', this.quit)
  }
}
</script>

<style scoped lang="scss">
.post{
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;

  .post-title {
    font-size: 30px;
    height: 45px;
    overflow: hidden;
    text-align: center;
    font-weight: bolder;
    color:white;
  }

  .post-content{
    display: flex;
    width: 390px;
    height: 670px;
    padding: 15px;
    color:white;
  }

  .phone_content{
    height: 100%;
  }

  .post-video, .post-image{
    object-fit: contain;
    max-width: 100%;
    max-height: 100%;
    width: auto;
    height: auto;
  }
}



</style>
