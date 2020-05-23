<template>
  <div class="boxes">
    <div class="chart" v-html="svg" />
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
@Component
export default class InputData extends Vue {
  @Prop() private svg!: string;
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.boxes {
  display: -webkit-flex;
  justify-content: center;
  height: 100%;
}
.chart {
  width: 600px;
  height: 600px;
}
</style>
