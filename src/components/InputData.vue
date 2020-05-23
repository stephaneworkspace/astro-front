<template>
  <div class="hello">
    <h3><strong>Vos coordonées</strong></h3>
    <section>
      <div class="form_astro">
        <div class="columns">
          <div class="column">
            <b-field label="Date de naissance">
              <b-datepicker
                placeholder="Votre date de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="ddmmyyyy"
                @input="onChange"
              >
              </b-datepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Heure de naissance">
              <b-timepicker
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                v-model="hhmm"
                @input="onChange"
                editable
              >
              </b-timepicker>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Fuseau horraire offset">
              <b-input
                placeholder="2 pour Genève"
                icon="clock"
                size="is-medium"
                v-model="offset"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Latitude">
              <b-input
                placeholder="Votre latitude de naissance"
                icon="compass"
                size="is-medium"
                v-model="lat"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Longitude">
              <b-input
                placeholder="Votre longitude de naissance"
                icon="compass"
                size="is-medium"
                v-model="lng"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
        </div>
      </div>
      <InputAspect :api="api" @change-aspect="updateAspect" />
      <!--
      <div class="column">
        <button class="button is-primary" v-on:click="svgNatal">
          Charger le thème astral
        </button>
      </div>
      -->
    </section>
    <div v-if="show">
      <NatalChart :svg="svg" />
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Prop, Vue } from "vue-property-decorator";
import NatalChart from "@/components/NatalChart.vue";
import InputAspect from "@/components/InputAspect.vue";
const axios = require("axios").default;

@Component({
  components: {
    NatalChart,
    InputAspect
  }
})
export default class InputData extends Vue {
  @Prop() private api!: string;
  public show = false;
  public valid = false;
  public ddmmyyyy: Date = new Date();
  public hhmm: Date = new Date();
  public offset = "2";
  public lat = 46.0222;
  public lng = 6.14569;
  public svg = "";
  public aspectSelect = 0;

  public onChange() {
    this.svgNatal();
  }

  public updateAspect(e): void {
    this.aspectSelect = e;
    this.svgNatal();
  }

  public svgNatal(): void {
    const config = {
      "Content-Type": "application/x-www-form-urlencoded"
    };
    const year = this.ddmmyyyy.getFullYear();
    const month = this.ddmmyyyy.getMonth();
    const day = this.ddmmyyyy.getDay();
    const hour =
      parseInt(this.hhmm.getHours().toString(), 10) +
      parseInt(this.offset.toString(), 10);
    const min = parseInt(this.hhmm.getMinutes().toString(), 10);
    axios
      .post(
        this.api + "svg_chart",
        "year=" +
          year +
          "&month=" +
          month +
          "&day=" +
          day +
          "&hour=" +
          hour +
          "&min=" +
          min +
          "&lat=" +
          this.lat +
          "&lng=" +
          this.lng +
          "&aspect=" +
          this.aspectSelect,
        config
      )
      .then(res => {
        this.svg = res.data;
        this.$forceUpdate();
      });
    this.show = true;
  }

  private created() {
    this.show = false;
    this.svgNatal();
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  font-size: 24px;
  margin: 10px 0 0;
}
a {
  color: #7957d5;
}
.form_astro {
  margin: 20px 20px 20px;
}
.aspect_text {
  justify-content: center;
}
.aspect_svg_select {
  width: 27px;
  height: 27px;
  margin: 27px;
  background: transparent;
}
.aspect_svg {
  width: 40px;
  height: 40px;
  margin: 40px;
  background: transparent;
}
</style>
