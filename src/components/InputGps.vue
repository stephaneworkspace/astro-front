<template>
  <div>
    <div class="columns">
      <div class="column">
        <b-field label="Recherche">
          <b-switch v-model="swAutoComplete" />
        </b-field>
      </div>
      <div class="column">
        <b-field :label="!swTransit ? 'Latitude' : 'Latitude de transit'">
          <b-input
            size="is-medium"
            icon="compass"
            v-if="!swAutoComplete"
            v-model="lat"
            :placeholder="
              !swTransit
                ? 'Votre latitude de naissance'
                : 'Votre latitude de transit'
            "
            @input="onChangeLat"
          >
          </b-input>
          <b-input
            size="is-medium"
            icon="compass"
            v-if="swAutoComplete"
            v-model="lat"
            :placeholder="
              !swTransit
                ? 'Votre latitude de naissance'
                : 'Votre latitude de transit'
            "
            disabled
          >
          </b-input>
        </b-field>
      </div>
      <div class="column">
        <b-field :label="!swTransit ? 'Longitude' : 'Longitude de transit'">
          <b-input
            size="is-medium"
            icon="compass"
            v-if="!swAutoComplete"
            v-model="lng"
            :placeholder="
              !swTransit
                ? 'Votre longitude de naissance'
                : 'Votre longitude de transit'
            "
            @input="onChangeLng"
          >
          </b-input>
          <b-input
            size="is-medium"
            icon="compass"
            v-if="swAutoComplete"
            v-model="lng"
            :placeholder="
              !swTransit
                ? 'Votre longitude de naissance'
                : 'Votre longitude de transit'
            "
            disabled
          >
          </b-input>
        </b-field>
      </div>
    </div>
    <div class="columns">
      <div class="column">
        <b-field :label="!swTransit ? 'Zone' : 'Zone lors du transit'">
          <b-select
            size="is-medium"
            icon="compass"
            v-model="tz"
            @input="onChangeTz"
            :placeholder="
              !swTransit
                ? 'Votre décalage horaire de naissance'
                : 'Votre décalage horaire lors du transit'
            "
          >
            <option
              v-for="option in listTimeZone"
              :value="option.d03_id"
              :key="option.d03_id"
            >
              {{ option.d03_text }}
              {{
                option.d03_offset >= 0
                  ? "(GMT+" + numberToHour(option.d03_offset) + ")"
                  : "(GMT-" + numberToHour(option.d03_offset * -1.0) + ")"
              }}
            </option>
          </b-select>
        </b-field>
      </div>
      <div class="column">
        <b-field label="Recherche par ville">
          <b-autocomplete
            size="is-medium"
            icon="compass"
            v-model="name"
            placeholder="Recherche"
            :field="!swTransit ? 'Ville de naissance' : 'Ville de transit'"
            :data="list"
            :loading="isFetching"
            :disabled="!swAutoComplete"
            @typing="getAsyncData"
            @input="onChangeSearch"
            @select="option => (selected = option)"
          >
            <template slot-scope="props">
              <div class="media">
                <div class="media-left">
                  <img :src="getFlag(props.option.country.toLowerCase())" />
                </div>
                <div class="media-content">
                  {{ props.option.name }}
                  <br />
                  <small
                    >Lat: {{ props.option.lat }} Lng:
                    {{ props.option.lng }}</small
                  >
                </div>
              </div>
            </template>
          </b-autocomplete>
        </b-field>
      </div>
    </div>
  </div>
</template>
<script lang="ts">
import { Component, Prop, /*Watch,*/ Vue } from "vue-property-decorator";
//import debounce from "loadash/debounce";
import { Debounce } from "vue-debounce-decorator";
import moment from "moment";
moment().format();
const axios = require("axios").default;

export interface FilterCity {
  country: string;
  name: string;
  lat: number;
  lng: number;
  tz_name: string;
  tz: FilterTz[];
}

export interface FilterTz {
  offset: number;
  text: string;
}

export interface D03TimeZoneInfo {
  d03_id: string;
  d03_offset: number;
  d03_text: string;
}

@Component({})
export default class InputData extends Vue {
  @Prop() private api!: string;
  @Prop() private swTransit!: boolean;
  public swAutoComplete = false;
  public list: FilterCity[] = [];
  /* eslint-disable @typescript-eslint/camelcase */
  public selected: FilterCity = {
    country: "".toString(),
    name: "".toString(),
    lat: 0,
    lng: 0,
    tz_name: "".toString(),
    tz: []
  };
  /* eslint-enable @typescript-eslint/camelcase */
  public listTimeZone: D03TimeZoneInfo[] = [];
  public isFetching = false;
  public lat = 46.20222;
  public lng = 6.14569;
  public name = "";
  public tz: string = "".toString();
  public offset = 2.0;
  public timeZoneDefault =
    "(UTC+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna";

  public numberToHour(nb: number): string {
    if (nb == 0.0) {
      return "00:00".toString();
    } else {
      return moment()
        .startOf("day")
        .add(parseFloat(nb.toString()), "hours")
        .format("hh:mm");
    }
  }

  public getFlag(country) {
    return require("../assets/" + country + ".png");
  }

  public onChangeSearch() {
    if (this.name == "") {
      /* eslint-disable @typescript-eslint/camelcase */
      this.selected = {
        country: "".toString(),
        name: "".toString(),
        lat: 0,
        lng: 0,
        tz_name: "".toString(),
        tz: []
      };
      /* eslint-enable @typescript-eslint/camelcase */
    }
    if (this.selected.name !== "") {
      this.listTimeZone.forEach(l => {
        this.selected.tz.forEach(t => {
          if (l.d03_text == t.text) {
            this.tz = l.d03_id;
            this.offset = l.d03_offset;
            return;
          }
        });
      });
      this.lat = this.selected.lat;
      this.lng = this.selected.lng;
      this.onChange();
      this.swAutoComplete = false;
    }
  }

  public onChangeLat(lat) {
    this.lat = lat;
    this.onChange();
  }

  public onChangeLng(lng) {
    this.lng = lng;
    this.onChange();
  }

  public onChangeTz(tz) {
    this.listTimeZone.forEach(l => {
      if (l.d03_id == tz) {
        this.offset = l.d03_offset;
      }
    });
    this.onChange();
  }

  public onChange() {
    this.$emit("change-lat-lng-offset", {
      lat: this.lat,
      lng: this.lng,
      offset: this.offset
    });
  }

  private mounted() {
    axios
      .get(this.api + "filter-city-time-zone")
      .then(res => {
        this.listTimeZone = res.data;
        this.listTimeZone.forEach(l => {
          if (l.d03_text == this.timeZoneDefault) {
            this.tz = l.d03_id;
          }
        });
      })
      .catch(error => {
        this.listTimeZone = [];
        throw error;
      });
  }

  //@Watch("getAsyncData")
  @Debounce(500)
  public async getAsyncData(name) {
    if (!name.length) {
      this.list = [];
      return;
    }
    this.isFetching = true;
    const config = {
      "Content-Type": "application/x-www-form-urlencoded,charset=utf-8"
    };
    axios
      .get(this.api + "filter-city/" + name, config)
      .then(res => {
        this.list = res.data;
        //this.$forceUpdate();
      })
      .catch(error => {
        this.list = [];
        throw error;
      })
      .finally(() => {
        this.isFetching = false;
      });
  }
}
</script>
<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.form-astro-gps {
  margin: 20px;
}
</style>
