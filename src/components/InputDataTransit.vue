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
          @change-lat-lng-offset="changeLatLngOffsetNatal"
        />
      </div>
    </section>
    <section class="section">
      <div class="container">
        <div class="columns">
          <div class="column">
            <b-field label="Jour du transit">
              <b-input
                placeholder="Votre jour de transit"
                icon="calendar-today"
                size="is-medium"
                v-model="ddTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Mois de transit">
              <b-input
                placeholder="Votre n° de mois de transit"
                icon="calendar-today"
                size="is-medium"
                v-model="mmTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
          <div class="column">
            <b-field label="Année de transit">
              <b-input
                placeholder="Votre année de transit"
                icon="calendar-today"
                size="is-medium"
                v-model="yyyyTransit"
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
                v-model="hhTransit"
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
                v-model="minuteTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
        </div>
        <InputGps
          :api="api"
          :swTransit="true"
          @change-lat-lng-offset="changeLatLngOffsetTransit"
        />
      </div>
    </section>
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

export interface DataObjectAspectSvg {
  svg: string;
  text: string;
  aspects: string[];
}

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
  public show2 = false;
  public valid = false;
  public yyyy: string = new Date().getFullYear().toString();
  public mm: string = (new Date().getMonth() + 1).toString();
  public dd: string = moment().format("DD");
  public hhmm: Date = new Date();
  public hh: string = new Date().getHours().toString();
  public minute: string = new Date().getMinutes().toString();
  public offset = 2.0;
  public lat = 46.20222;
  public lng = 6.14569;
  public yyyyTransit: string = new Date().getFullYear().toString();
  public mmTransit: string = (new Date().getMonth() + 1).toString();
  public ddTransit: string = moment().format("DD");
  public hhmmTransit: Date = new Date();
  public hhTransit: string = new Date().getHours().toString();
  public minuteTransit: string = new Date().getMinutes().toString();
  public offsetTransit = 2.0;
  public latTransit = 46.20222;
  public lngTransit = 6.14569;
  public svg = "";
  public aspectSelect = 0;

  public changeLatLngOffsetNatal(e) {
    this.lat = e.lat;
    this.lng = e.lng;
    this.offset = e.offset;
    this.svgNatal();
  }

  public changeLatLngOffsetTransit(e) {
    this.latTransit = e.lat;
    this.lngTransit = e.lng;
    this.offsetTransit = e.offset;
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
        this.api + "svg_chart_transit",
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
          "&time_zone=" +
          this.offset +
          "&year_t=" +
          parseInt(this.yyyyTransit, 10) +
          "&month_t=" +
          parseInt(this.mmTransit, 10) +
          "&day_t=" +
          parseInt(this.ddTransit, 10) +
          "&hour_t=" +
          parseInt(this.hhTransit, 10) +
          "&min_t=" +
          parseInt(this.minuteTransit, 10) +
          "&lat_t=" +
          this.latTransit +
          "&lng_t=" +
          this.lngTransit +
          "&time_zone_t=" +
          this.offsetTransit +
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
</style>
