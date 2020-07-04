<template>
<div class="shop-menu">
  <vs-row>
    <vs-col class="header" vs-offset="2" vs-type="flex" vs-justify="center" vs-align="center" vs-w="8">
      <h1>Titre</h1>
    </vs-col>
  </vs-row>
  <vs-row>
    <vs-col class="content" vs-offset="0" vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
      offset - 8
    </vs-col>
  </vs-row>
</div>
</template>


<script>
export default {
  data() {
    return{};
  }
}
</script>

<style lang="scss" scoped>

$radius: 25px;

.shop-menu{
  height: 100%;
  width: 100%;
  background-color: red;
  border-radius: $radius;
  padding: 15px;

  .header{
    height: 50px;
    color: white;
    margin: 15px;
  }
  .content{
    background-color: white;
    height: 630px;
    max-height: 630px;
    border-radius: $radius;
  }
}
</style>
