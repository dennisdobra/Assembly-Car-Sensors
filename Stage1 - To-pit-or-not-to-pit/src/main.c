#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"

void read(sensor **vector, int nr_sensors, FILE *file)
{
    // Allocate the sensor vector of size nr_sensors
    *vector = malloc(nr_sensors * sizeof(sensor));

    int i = 0;
    while (nr_sensors != i) {

        // Read the sensor type
        int tip_senzor;
        fread(&tip_senzor, sizeof(int), 1, file);
        (*vector)[i].sensor_type = tip_senzor;

        if ((*vector)[i].sensor_type == 0) { // Tire sensor
            // Allocate space for the sensor type
            (*vector)[i].sensor_data = malloc(sizeof(tire_sensor));
            // Read the sensor data
            float x;
            int y;
            // Read one value from the file and store it in the sensor data
            fread(&x, sizeof(float), 1, file);
            ((tire_sensor *)(*vector)[i].sensor_data)->pressure = x;
            fread(&x, sizeof(float), 1, file);
            ((tire_sensor *)(*vector)[i].sensor_data)->temperature = x;
            fread(&y, sizeof(int), 1, file);
            ((tire_sensor *)(*vector)[i].sensor_data)->wear_level = y;
            fread(&y, sizeof(int), 1, file);
            ((tire_sensor *)(*vector)[i].sensor_data)->performace_score = y;
        } else if ((*vector)[i].sensor_type == 1) { // PMU sensor
            // Allocate space for the sensor type
            (*vector)[i].sensor_data = malloc(sizeof(power_management_unit));
            // Read the sensor data
            float x;
            int y;
            fread(&x, sizeof(float), 1, file);
            ((power_management_unit *)(*vector)[i].sensor_data)->voltage = x;

            fread(&x, sizeof(float), 1, file);
            ((power_management_unit *)(*vector)[i].sensor_data)->current = x;

            fread(&x, sizeof(float), 1, file);
            // Shorten the line to be less than 80 characters
            void *data = (*vector)[i].sensor_data;
            ((power_management_unit *)data)->power_consumption = x;

            fread(&y, sizeof(int), 1, file);
            // data = (*vector)[i]->sensor_data;
            ((power_management_unit *)data)->energy_regen = y;

            fread(&y, sizeof(int), 1, file);
            // data = (*vector)[i]->sensor_data;
            ((power_management_unit *)data)->energy_storage = y;
        }
        // Read the number of operations
        int nr_of_operations;
        fread(&nr_of_operations, sizeof(int), 1, file);
        ((*vector)[i].nr_operations) = nr_of_operations;

        int nr_op = (*vector)[i].nr_operations;
        (*vector)[i].operations_idxs = malloc(nr_op * sizeof(int));

        int operation;
        for (int j = 0; j < nr_op; j++) {
            fread(&operation, sizeof(int), 1, file);
            (*vector)[i].operations_idxs[j] = operation;
        }
        i++;
    }
}

void print_sensor(sensor *vector, int nr_sensors, int index)
{
    if (index < 0 || index >= nr_sensors) {
        printf("Index not in range!\n");
        return;
    }

    int k = -1;
    for (int i = 0; i < nr_sensors; i++) {
        // This means it's a PMU type sensor
        if (vector[i].sensor_type == 1) {
            k++;
            if (k == index) {
                power_management_unit *data;
                data = (power_management_unit *)vector[i].sensor_data;

                printf("Power Management Unit\n");
                printf("Voltage: %.2f\n", (data)->voltage);
                printf("Current: %.2f\n", (data)->current);
                printf("Power Consumption: %.2f\n", (data)->power_consumption);
                printf("Energy Regen: %d%%\n", (data)->energy_regen);
                printf("Energy Storage: %d%%\n", (data)->energy_storage);
            }
        }
    }
    for (int i = 0; i < nr_sensors; i++) {
        // This means it's a tire type sensor
        if (vector[i].sensor_type == 0) {
            k++;
            if (k == index) {
                tire_sensor *data;
                data = (tire_sensor *)vector[i].sensor_data;

                printf("Tire Sensor\n");
                printf("Pressure: %.2f\n", (data)->pressure);
                printf("Temperature: %.2f\n", (data)->temperature);
                printf("Wear Level: %d%%\n", (data)->wear_level);
                if ((data)->performace_score == 0) {
                    printf("Performance Score: Not Calculated\n");
                } else {
                    int score = (data)->performace_score;
                    printf("Performance Score: %d\n", score);
                }
            }
        }
    }
}

void analyze(sensor *vector, int index, int nr_sensors)
{
    void (*op_vector[8])(void *); // Function vector
    get_operations((void **)op_vector);

    int k = -1;

    for (int i = 0; i < nr_sensors; i++) {
        // This means it's a PMU type sensor
        if (vector[i].sensor_type == 1) {
            k++;
            if (k == index) {
                for (int j = 0; j < vector[i].nr_operations; j++) {
                    op_vector[vector[i].operations_idxs[j]]
                    (vector[i].sensor_data);
                }
                return;
            }
        }
    }
    for (int i = 0; i < nr_sensors; i++) {
        // This means it's a tire type sensor
        if (vector[i].sensor_type == 0) {
            k++;
            if (k == index) {
                for (int j = 0; j < vector[i].nr_operations; j++) {
                    op_vector[vector[i].operations_idxs[j]]
                    (vector[i].sensor_data);
                }
                return;
            }
        }
    }
}

void iesire(sensor *vector, int nr_sensors)
{
    for (int i = 0; i < nr_sensors; i++) {
        free(vector[i].sensor_data);
        free(vector[i].operations_idxs);
    }
    free(vector);
}

void clear(sensor **vector, int *nr_sensors)
{
    int j = 0;
    for (int i = 0; i < (*nr_sensors); i++) {

        if ((*vector)[i].sensor_type == 0) {
            // Variable taken for coding style
            tire_sensor *data = (tire_sensor *)(*vector)[i].sensor_data;

            float pressure = (data)->pressure;
            float temperature = (data)->temperature;
            int wear_level = (data)->wear_level;

            if ((pressure >= 19 && pressure <= 28) &&
            (temperature >= 0 && temperature <= 120) &&
            (wear_level >= 0 && wear_level <= 100)) {
                (*vector)[j] = (*vector)[i];
                j++;
            } else {
                free((*vector)[i].sensor_data);
                free((*vector)[i].operations_idxs);
            }
        } else {
            void *data = (*vector)[i].sensor_data;
            power_management_unit *cast = (power_management_unit *)data;

            float voltage = ((power_management_unit *)data)->voltage;
            float current = ((power_management_unit *)data)->current;
            float power_consumption = (cast)->power_consumption;
            int energy_regen = ((power_management_unit *)data)->energy_regen;
            int energy_storage = (cast)->energy_storage;

            if ((voltage >= 10 && voltage <= 20) &&
            (current >= -100 && current <= 100) &&
            (power_consumption >= 0 && power_consumption <= 1000) &&
            (energy_regen >= 0 && energy_regen <= 100) &&
            (energy_storage >= 0 && energy_storage <= 100)) {
                (*vector)[j] = (*vector)[i];
                j++;
            } else {
                free((*vector)[i].sensor_data);
                free((*vector)[i].operations_idxs);
            }
        }
    }
    *vector = realloc(*vector, j * sizeof(sensor));
    (*nr_sensors) = j;
}

int main(int argc, char const *argv[])
{
    // Open the file to read from
    FILE *file = fopen(argv[1], "rb");
    // Defensive programming
    if (file == NULL) {
        printf("Could not open file %s.\n", argv[1]);
        return 1;
    }

    char command[10];
    int index;
    sensor *vector;
    int nr_sensors;

    fread(&nr_sensors, sizeof(int), 1, file);

    read(&vector, nr_sensors, file);

    while (1) {
        scanf("%s", command);
        if (strncmp(command, "print", 5) == 0) {
            scanf("%d", &index);
            print_sensor(vector, nr_sensors, index);
        } else if (strncmp(command, "analyze", 7) == 0) {
            scanf("%d", &index);
            analyze(vector, index, nr_sensors);
        } else if (strncmp(command, "exit", 4) == 0) {
            break;
        } else if (strncmp(command, "clear", 5) == 0) {
            clear(&vector, &nr_sensors);
        }
    }

    iesire(vector, nr_sensors);
    fclose(file);
    return 0;
}
