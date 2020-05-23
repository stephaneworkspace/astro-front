<template>
  <div class="home">
    <img class="logo" alt="Vue logo" src="../assets/logo.png" />
    <InputData api="https://www.astrologie-traditionnelle.net/api/" />
  </div>
</template>

<script>
// @ is an alias to /src
import InputData from "@/components/InputData.vue";

export default {
  name: "Home",
  components: {
    InputData
  }
};
</script>
<style>
.logo {
  width: 622px;
  height: 300px;
}
</style>
