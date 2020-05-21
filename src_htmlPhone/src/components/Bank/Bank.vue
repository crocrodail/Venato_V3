<template>
  <div style="width: 326px; height: 743px;" class="screen">
    <InfoBare />
    <div class="elements">
      <CreditCard :bankAccount='bankAccount' :fullname="bankFullname"></CreditCard>
      <div class="solde">
      <vs-row vs-w="12">
        <vs-col vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
          SOLDE COMPTE EN BANQUE
        </vs-col>
        <vs-col class="amount" vs-type="flex" vs-justify="center" vs-align="center" vs-w="12">
          {{bankAmontFormat}}
        </vs-col>
      </vs-row>
      </div>
    </div>
    <img class="logo_tarj_end" src="/html/static/img/app_bank/tarjetas.png" />
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import InfoBare from "../InfoBare";
import CreditCard from "./CreditCard";
export default {
  components: {
    InfoBare,
    CreditCard
  },
  data() {
    return {
      id: "",
      paratutar: "",
      currentSelect: 0
    };
  },
  methods: {
    ...mapActions(["sendpara"]),
    scrollIntoViewIfNeeded: function() {
      this.$nextTick(() => {
        document.querySelector("focus").scrollIntoViewIfNeeded();
      });
    },
    onBackspace() {
      this.$router.push({ name: 'menu' })
    },
  },
  computed: {
    ...mapGetters(["bankAmont", "bankAccount", "bankFullname", "IntlString"]),
    bankAmontFormat() {
      return Intl.NumberFormat().format(this.bankAmont) + ' $';
    }
  },
  created() {
    this.display = this.$route.params.display;
    this.$bus.$on("keyUpBackspace", this.onBackspace);
  },
  beforeDestroy() {
    this.$bus.$off("keyUpBackspace", this.onBackspace);
  }
};
</script>

<style lang="scss" scoped>
.screen {
  position: relative;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: #e9e9e9;

  .elements {
    height: 87%;
    width: 100%;
    margin: auto;
    overflow-y: auto;
    .credit_card {
      position: relative;
      top: 0;
      left: 0;
      width: 100%;
    }
  }

  .logo_tarj_end {
    width: 90%;
    margin-left: 5%;
    flex-shrink: 0;
    height: 10%;
  }
}

.num-tarj {
  margin-top: -88px;
  margin-left: 50px;
}

.solde {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica,
    Arial, sans-serif;
  font-weight: 200;
  color: black;
  padding-top: 40px;
  font-size: 16px;
  .amount{
    font-size: 30px;
    font-weight: 800;
  }
}

</style>
