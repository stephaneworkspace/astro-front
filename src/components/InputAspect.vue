<template>
  <div v-if="showAspects">
    <label class="label">Aspects</label>
    <div class="aspect-text">
      {{ aspects[aspectSelect].text }}
    </div>
    <div class="columns">
      <div v-for="(aspect, i) in aspects" :key="aspect.text" class="column">
        <div
          class="aspect-svg-select"
          v-html="aspect.svg"
          @click="clickAspect(i)"
        />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
const axios = require("axios").default;

export interface DataObjectAspectSvg {
  svg: string;
  text: string;
  aspects: string[];
}

@Component({})
export default class InputData extends Vue {
  @Prop() private api!: string;

  public showAspects = false;
  public aspects: DataObjectAspectSvg[] = [];
  public aspectSelect = 0;
  public clickAspect(i): void {
    this.aspectSelect = i;
    this.$emit("change-aspect", this.aspectSelect);
    this.$buefy.toast.open({
      duration: 1000,
      message: this.aspects[this.aspectSelect].text,
      position: "is-bottom"
    });
  }

  private created() {
    this.getAspects();
  }

  private getAspects() {
    const config = {
      "Content-Type": "application/json"
    };
    axios.get(this.api + "aspects.json", config).then(res => {
      this.aspects = res.data;
      this.showAspects = true;
    });
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.aspect-text {
  justify-content: center;
}
.aspect-svg-select {
  width: 27px;
  height: 27px;
  margin: 27px;
  background: transparent;
}
</style>
