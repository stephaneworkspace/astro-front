<template>
  <div>
    <h3><strong>Vos coordonées</strong></h3>
    <section class="section">
      <div class="container">
        <div class="columns">
          <div class="column">
            <b-field label="Jour de naissance">
              <b-input
                placeholder="Votre jour de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="dd"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Mois de naissance">
              <b-input
                placeholder="Votre n° de mois de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="mm"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Année de naissance">
              <b-input
                placeholder="Votre année de naissance"
                icon="calendar-today"
                size="is-medium"
                v-model="yyyy"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Heure de naissance">
              <b-input
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                v-model="hh"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Minute de naissance">
              <b-input
                placeholder="Votre minute de naissance"
                icon="clock"
                size="is-medium"
                v-model="minute"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
        </div>
        <InputGps
          :api="api"
          :swTransit="false"
          @change-lat-lng-offset="changeLatLngOffset"
        />
      </div>
    <section class="section">
      <div class="container">
        <InputAspect :api="api" @change-aspect="updateAspect" />
      </div>
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
import InputGps from "@/components/InputGps.vue";
import moment from "moment";
const axios = require("axios").default;
//const moment = require("moment");
//moment().format();

@Component({
  components: {
    NatalChart,
    InputAspect,
    InputGps
  }
})
export default class InputData extends Vue {
  @Prop() private api!: string;
  public show = false;
  public valid = false;
  // public ddmmyyyy: Date = new Date();
  public yyyy: string = new Date().getFullYear().toString();
  public mm: string = (new Date().getMonth() + 1).toString();
  public dd: string = moment().format("DD");
  public hhmm: Date = new Date();
  public hh: string = new Date().getHours().toString();
  public minute: string = new Date().getMinutes().toString();
  public lat = 46.20222;
  public lng = 6.14569;
  public offset = 2.0;
  public svg = "";
  public aspectSelect = 0;

  public changeLatLngOffset(e) {
    this.lat = e.lat;
    this.lng = e.lng;
    this.offset = e.offset;
    this.svgNatal();
  }

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
    axios
      .post(
        `${this.api}svg_chart`,
        "year=" +
          parseInt(this.yyyy, 10) +
          "&month=" +
          parseInt(this.mm, 10) +
          "&day=" +
          parseInt(this.dd, 10) +
          "&hour=" +
          parseInt(this.hh, 10) +
          "&min=" +
          parseInt(this.minute, 10) +
          "&lat=" +
          this.lat +
          "&lng=" +
          this.lng +
          "&aspect=" +
          this.aspectSelect +
          "&time_zone=" +
          this.offset,
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
.form-astro {
  margin: 20px 20px 20px;
}
</style>
