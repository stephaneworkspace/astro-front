<template>
  <div class="hello">
    <h3><strong>Vos coordonées</strong></h3>
    <section>
      <div class="form-astro">
        <div class="columns">
          <!--          <div class="column">
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
-->
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
          <!--
          <div class="column">
            <b-field label="Heure de naissance">
              <b-timepicker
                placeholder="Votre heure de naissance"
                icon="clock"
                size="is-medium"
                v-model="hhmm"
                @input="onChange"
              >
              </b-timepicker>
            </b-field>
          </div>
-->
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
          <!--          <div class="column">
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
-->
        </div>
        <InputGps
          :api="api"
          :swTransit="false"
          @change-lat-lng="changeLatLngNatal"
        />
        <div class="columns">
          <!--
          <div class="column">
            <b-field label="Date du transit">
              <b-datepicker
                placeholder="Votre date de transit"
                icon="calendar-today"
                size="is-medium"
                v-model="ddmmyyyyTransit"
                @input="onChange"
              >
              </b-datepicker>
            </b-field>
          </div>
-->
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
          <!--
          <div class="column">
            <b-field label="Heure de transit">
              <b-timepicker
                placeholder="Votre heure de transit"
                icon="clock"
                size="is-medium"
                v-model="hhmmTransit"
                @input="onChange"
                editable
              >
              </b-timepicker>
            </b-field>
          </div>
-->
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

          <!--
          <div class="column">
            <b-field label="Fuseau horraire offseti transit">
              <b-input
                placeholder="2 pour Genève"
                icon="clock"
                size="is-medium"
                v-model="offsetTransit"
                @input="onChange"
              >
              </b-input>
            </b-field>
          </div>
-->
        </div>
      </div>
      <InputGps
        :api="api"
        :swTransit="true"
        @change-lat-lng="changeLatLngTransit"
      />
      <InputAspect :api="api" @change-aspect="updateAspect" />
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
  //public ddmmyyyy: Date = new Date();
  public yyyy: string = new Date().getFullYear().toString();
  public mm: string = (new Date().getMonth() + 1).toString();
  public dd: string = moment().format("DD");
  public hhmm: Date = new Date();
  public hh: string = new Date().getHours().toString();
  public minute: string = new Date().getMinutes().toString();
  public offset = "2";
  public lat = 46.0222;
  public lng = 6.14569;
  //public ddmmyyyyTransit: Date = new Date();
  public yyyyTransit: string = new Date().getFullYear().toString();
  public mmTransit: string = (new Date().getMonth() + 1).toString();
  public ddTransit: string = moment().format("DD");
  public hhmmTransit: Date = new Date();
  public hhTransit: string = new Date().getHours().toString();
  public minuteTransit: string = new Date().getMinutes().toString();
  public offsetTransit = "2";
  public latTransit = 46.0222;
  public lngTransit = 6.14569;
  public svg = "";
  public aspectSelect = 0;

  public changeLatLngNatal(e) {
    this.lat = e.lat;
    this.lng = e.lng;
    this.svgNatal();
  }

  public changeLatLngTransit(e) {
    this.latTransit = e.lat;
    this.lngTransit = e.lng;
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
    /*const year = this.ddmmyyyy.getFullYear();
    // const month = this.ddmmyyyy.getMonth(); // BUG
    // const day = this.ddmmyyyy.getDay(); // BUG
    const day = this.ddmmyyyy.getMonth();
    const month = this.ddmmyyyy.getDay();
    const hour = parseInt(this.hhmm.getHours().toString(), 10);
    //   parseInt(this.offset.toString(), 10);
    const min = parseInt(this.hhmm.getMinutes().toString(), 10);
    const yearT = this.ddmmyyyyTransit.getFullYear();
    // const monthT = this.ddmmyyyyTransit.getMonth(); // BUG
    // const dayT = this.ddmmyyyyTransit.getDay(); // BUG
    const dayT = this.ddmmyyyyTransit.getMonth();
    const monthT = this.ddmmyyyyTransit.getDay();
    const hourT = parseInt(this.hhmmTransit.getHours().toString(), 10);
    //parseInt(this.offsetTransit.toString(), 10);
    const minT = parseInt(this.hhmmTransit.getMinutes().toString(), 10);
    */
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
          "&time_zone=1.0" +
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
          "&time_zone_t=1.0" +
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
.form-astro {
  margin: 20px 20px 20px;
}
</style>
