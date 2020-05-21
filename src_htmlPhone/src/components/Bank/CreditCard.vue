<template>
  <div class="card-item">
    <div class="card-item__side -front">
      <div
        class="card-item__focus"
        v-bind:class="{'-active' : focusElementStyle }"
        v-bind:style="focusElementStyle"
        ref="focusElement"
      ></div>
      <div class="card-item__cover">
        <img
          v-bind:src="'https://raw.githubusercontent.com/muhammederdem/credit-card-form/master/src/assets/images/' + currentCardBackground + '.jpeg'"
          class="card-item__bg"
        />
      </div>

      <div class="card-item__wrapper">
        <div class="card-item__top">
          <img
            src="/html/static/img/app_bank/chip.png"
            class="card-item__chip"
          />
          <div class="card-item__type">
            <transition name="slide-fade-up">
              <img
                src="/html/static/img/app_bank/bank.png"
                alt
                class="card-item__typeImg"
              />
            </transition>
          </div>
        </div>
        <label for="cardNumber" class="card-item__number" ref="cardNumber">
          {{bankAccount}}
        </label>
        <div class="card-item__content">
          <label for="cardName" class="card-item__info" ref="cardName">
            <div class="card-item__holder">Propriétaire</div>
            <transition name="slide-fade-up">
              <div class="card-item__name" key="2">{{fullname}}</div>
            </transition>
          </label>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    fullname: String,
    bankAccount: String
  },
  data() {
    return {
      currentCardBackground: Math.floor(Math.random() * 25 + 1), // just for fun :D
      cardName: "",
      cardNumber: "",
      cardMonth: "",
      cardYear: "",
      cardCvv: "",
      minCardYear: new Date().getFullYear(),
      otherCardMask: "#### ##### ###",
      cardNumberTemp: "",
      isCardFlipped: false,
      focusElementStyle: null,
      isInputFocused: false
    };
  },
  mounted() {
    this.cardNumberTemp = this.otherCardMask;
  }
};
</script>

<style lang="scss" scoped>
@import url("https://fonts.googleapis.com/css?family=Source+Code+Pro:400,500,600,700|Source+Sans+Pro:400,600,700&display=swap");

.card-item {
  height: 195px;
  margin-left: auto;
  margin-right: auto;
  margin-top: 25px;
  position: relative;
  z-index: 2;
  width: 90%;

  &__focus {
    position: absolute;
    z-index: 3;
    border-radius: 5px;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    transition: all 0.35s cubic-bezier(0.71, 0.03, 0.56, 0.85);
    opacity: 0;
    pointer-events: none;
    overflow: hidden;
    border: 2px solid rgba(255, 255, 255, 0.65);

    &:after {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      background: rgb(8, 20, 47);
      height: 100%;
      border-radius: 5px;
      filter: blur(25px);
      opacity: 0.5;
    }

    &.-active {
      opacity: 1;
    }
  }

  &__side {
    border-radius: 15px;
    overflow: hidden;
    // box-shadow: 3px 13px 30px 0px rgba(11, 19, 41, 0.5);
    box-shadow: 0 20px 60px 0 rgba(14, 42, 90, 0.55);
    transform: perspective(2000px) rotateY(0deg) rotateX(0deg) rotate(0deg);
    transform-style: preserve-3d;
    transition: all 0.8s cubic-bezier(0.71, 0.03, 0.56, 0.85);
    backface-visibility: hidden;
    height: 100%;

    &.-back {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      transform: perspective(2000px) rotateY(-180deg) rotateX(0deg) rotate(0deg);
      z-index: 2;
      padding: 0;
      // background-color: #2364d2;
      // background-image: linear-gradient(
      //   43deg,
      //   #4158d0 0%,
      //   #8555c7 46%,
      //   #2364d2 100%
      // );
      height: 100%;

      .card-item__cover {
        transform: rotateY(-180deg);
      }
    }
  }
  &__bg {
    max-width: 100%;
    display: block;
    max-height: 100%;
    height: 100%;
    width: 100%;
    object-fit: cover;
  }
  &__cover {
    height: 100%;
    background-color: #1c1d27;
    position: absolute;
    height: 100%;
    background-color: #1c1d27;
    left: 0;
    top: 0;
    width: 100%;
    border-radius: 15px;
    overflow: hidden;
    &:after {
      content: "";
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background: rgba(6, 2, 29, 0.45);
    }
  }

  &__top {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    margin-bottom: 15px;
    padding: 0 10px;
  }

  &__chip {
    width: 40px;
  }

  &__type {
    height: 35px;
    position: relative;
    display: flex;
    justify-content: flex-end;
    max-width: 100px;
    margin-left: auto;
    width: 100%;
  }

  &__typeImg {
    max-width: 100%;
    object-fit: contain;
    max-height: 100%;
    object-position: top right;
  }

  &__info {
    color: #fff;
    width: 100%;
    max-width: calc(100% - 85px);
    padding: 10px;
    font-weight: 500;
    display: block;
    cursor: pointer;
  }

  &__holder {
    opacity: 0.7;
    font-size: 12px;
      margin-bottom: 5px;

  }

  &__wrapper {
    font-family: "Source Code Pro", monospace;
     padding: 20px 10px;
    position: relative;
    z-index: 4;
    height: 100%;
    text-shadow: 7px 6px 10px rgba(14, 42, 90, 0.8);
    user-select: none;
  }

  &__name {
    font-size: 16px;
    line-height: 1;
    white-space: nowrap;
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    text-transform: uppercase;
  }
  &__nameItem {
    display: inline-block;
    min-width: 8px;
    position: relative;
  }

  &__number {
    font-weight: 500;
    line-height: 1;
    color: #fff;
    font-size: 19px;
      margin-bottom: 10px;
      padding: 10px 10px;
    display: inline-block;
    cursor: pointer;
  }

  &__numberItem {
    display: inline-block;
    width: 12px;

      &.-active {
        width: 8px;
      }
  }

  &__content {
    color: #fff;
    display: flex;
    align-items: flex-start;
  }

  &__date {
    flex-wrap: wrap;
    font-size: 16px;
    margin-left: auto;
    padding: 10px;
    display: inline-flex;
    width: 80px;
    white-space: nowrap;
    flex-shrink: 0;
    cursor: pointer;
  }

  &__dateItem {
    position: relative;
    span {
      width: 22px;
      display: inline-block;
    }
  }

  &__dateTitle {
    opacity: 0.7;
    font-size: 12px;
      padding-bottom: 5px;
    width: 100%;
  }
  &__band {
    background: rgba(0, 0, 19, 0.8);
    width: 100%;
    height: 40px;
      margin-top: 10px;
    position: relative;
    z-index: 2;
  }

  &__cvv {
    text-align: right;
    position: relative;
    z-index: 2;
    padding: 10px 15px;
    .card-item__type {
      opacity: 0.7;
    }
  }
  &__cvvTitle {
    padding-right: 10px;
    font-size: 15px;
    font-weight: 500;
    color: #fff;
    margin-bottom: 5px;
  }
  &__cvvBand {
    height: 40px;
    background: #fff;
     margin-bottom: 15px;
    text-align: right;
    display: flex;
    align-items: center;
    justify-content: flex-end;
    padding-right: 10px;
    color: #1a3b5d;
    font-size: 18px;
    border-radius: 4px;
    box-shadow: 0px 10px 20px -7px rgba(32, 56, 117, 0.35);
  }
}
</style>
