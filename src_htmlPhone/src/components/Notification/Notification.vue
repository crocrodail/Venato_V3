<template>
  <div class="notification">
    <vs-row vs-w="12">
      <vs-col vs-type="flex" vs-justify="center" vs-align="center" vs-w="1">
        <img :src="icon"/>
      </vs-col>
      <vs-col vs-type="flex" vs-justify="left" class="source" vs-align="center" vs-w="11">
        {{source}}
      </vs-col>
      <vs-col vs-type="flex" vs-justify="left" class="title" vs-align="center" vs-w="12">
        {{title}}
      </vs-col>
      <vs-col vs-type="flex" vs-justify="left" class="message" vs-align="center" vs-w="12">
        <span v-html="message"></span>
      </vs-col>
    </vs-row>
  </div>
</template>

<script>
export default {
  props: {
    icon: String,
    source: String,
    title: String,
    message: String
  },
  data() {
    return {
      // currentCardBackground: Math.floor(Math.random() * 25 + 1), // just for fun :D
    };
  },
  mounted() {
  }
};
</script>

<style lang="scss" scoped>
.notification{
  min-height:50px;
  background-color: rgba(43, 43, 43, 0.8);
  display: flex;
  padding: 12px;
  border-radius: 10px;
  margin-bottom: 5px;
  box-shadow: 0 2px 2px 0 rgba(0,0,0,.14), 0 3px 1px -2px rgba(0,0,0,.2), 0 1px 5px 0 rgba(0,0,0,.12);
  img{
    width: 100%;
  }
  .source{
    font-weight: 500;
    color: rgb(154, 167, 199);
    text-transform: uppercase;
    font-size: 13px;
    padding-left: 5px;
  }
  .title{
    font-weight: 600;
    color: rgb(255, 255, 255);
    font-size: 15px;
    padding-left: 5px;
  }
  .message{
    color: rgb(255, 255, 255);
    font-size: 15px;
    padding-left: 5px;
  }
}
</style>
