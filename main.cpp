#include <iostream>
#include <vector>
#include <cmath>

std::vector<double> normalizedResistances{1e2, 1.2e2, 1.5e2, 1.8e2, 2.2e2, 2.7e2, 3.3e2, 3.9e2, 4.3e2, 4.7e2, 5.6e2, 6.8e2,
                                          8.2e2, 1e3, 1.2e3, 1.5e3, 1.8e3, 2.2e3, 2.7e3, 3.3e3, 3.9e3, 4.3e3, 4.7e3, 5.6e3, 6.8e3,
                                          8.2e3, 1e4, 1.2e4, 1.5e4, 1.8e4, 2.2e4, 2.7e4, 3.3e4, 3.9e4, 4.3e4, 4.7e4, 5.6e4, 6.8e4,
                                          8.2e4, 1e5, 1.2e5, 1.5e5, 1.8e5, 2.2e5, 2.7e5, 3.3e5, 3.9e5, 4.3e5, 4.7e5, 5.6e5, 6.8e5,
                                          8.2e5, 1e6, 1.2e6};

struct Values {
    double Wo;
    double Q;
    double Ho;
    double C;
    double R1, R2, R3;
    double Woerror, Qerror;

    explicit Values(double Wo = 0, double Q = 0) : Wo(Wo), Q(Q) {
        Ho = 0;
        C = 0;
        R1 = R2 = R3 = 0;
        Woerror = Qerror = 0;
    };
};

void normalizeResistance(double& resistance) {
    double low{0}, high{0};
    bool normalized = false;
    for (int i = 0; i < normalizedResistances.size() - 1; ++i) {
        int j = std::max(i - 1, 0);
        if (resistance < normalizedResistances.at(i)) {
            low = resistance - normalizedResistances.at(j);
            high = normalizedResistances.at(i) - resistance;
            resistance = ( (high - low) > 0) ? normalizedResistances.at(j) : normalizedResistances.at(i);
            normalized = true;
            break;
        }
    }
    if (!normalized) {
        resistance = 1;
    }
}

void calculateValues(double Ho, Values& currTransfer) {
    currTransfer.R2 = (2*currTransfer.Q) / (currTransfer.C*currTransfer.Wo);
    currTransfer.R1 = currTransfer.R2 / (2*Ho);
    currTransfer.R3 = currTransfer.R1 / ( (2*pow(currTransfer.Q, 2) / Ho) - 1);
    normalizeResistance(currTransfer.R2);
    normalizeResistance(currTransfer.R1);
    normalizeResistance(currTransfer.R3);
}

double calculateError(Values& transfer1, Values& transfer2) {
    double Wo = std::sqrt( (1+transfer1.R1/transfer1.R3) / (pow(transfer1.C, 2)*transfer1.R1*transfer1.R2));
    double Q = transfer1.C*transfer1.R2*Wo / 2;
    transfer1.Woerror = std::abs(Wo - transfer1.Wo)/Wo * 100;
    transfer1.Qerror = std::abs(Q - transfer1.Q)/Q * 100;
    double relativeError = std::abs(Wo - transfer1.Wo)/Wo + std::abs(Q - transfer1.Q)/Q;
    Wo = std::sqrt( (1+transfer2.R1/transfer2.R3) / (pow(transfer2.C, 2)*transfer2.R1*transfer2.R2));
    Q = transfer2.C*transfer2.R2*Wo / 2;
    transfer2.Woerror = std::abs(Wo - transfer2.Wo)/Wo * 100;
    transfer2.Qerror = std::abs(Q - transfer2.Q)/Q * 100;
    relativeError += std::abs(Wo - transfer2.Wo)/Wo + std::abs(Q - transfer2.Q)/Q;
    return relativeError*100;
}

int main() {

    Values bestTransfer1(607.2538181, 14.18555209), bestTransfer2(650.2087408, 14.118984);
    Values currTransfer1(607.2538181, 14.18555209), currTransfer2(650.2087408, 14.118984);
    double bestError = 100; //le pongo un valor alto para que lo descarte en la primera iteracion, se mide en %
    double currError = 0;
    std::vector<double> capacities{33e-9, 47e-9, 56e-9, 68-9, 82e-9, 100e-9, 120e-9, 220e-9, 330e-9, 470e-9,
                                   560e-9, 680e-9, 820e-9};
    double Ho = 0.1;

    for (double capacity1 : capacities) {
        currTransfer1.C = capacity1;
        for (double capacity2 : capacities) {

            currTransfer2.C = capacity2;
            Ho = 0.01;
            while (Ho < 70) {
                calculateValues(Ho, currTransfer1);
                calculateValues(2/Ho, currTransfer2);
                currError = calculateError(currTransfer1, currTransfer2);
                if (currError < bestError) {
                    bestTransfer1 = currTransfer1;
                    bestTransfer2 = currTransfer2;
                    bestTransfer1.Ho = Ho;
                    bestTransfer2.Ho = 2/Ho;
                    bestError = currError;
                }
                Ho += 0.01;
            }

        }
    }

    std::cout << bestError << std::endl;
    std::cout << "T1" << std::endl;
    std::cout << "C = " << bestTransfer1.C << std::endl;
    std::cout << "Ho = " << bestTransfer1.Ho << std::endl;
    std::cout << "R1 = " << bestTransfer1.R1 << std::endl;
    std::cout << "R2 = " << bestTransfer1.R2 << std::endl;
    std::cout << "R3 = " << bestTransfer1.R3 << std::endl;
    std::cout << "Wo Error =  = " << bestTransfer1.Woerror << std::endl;
    std::cout << "Q Error =  = " << bestTransfer1.Qerror << std::endl << std::endl;


    std::cout << "T2" << std::endl;
    std::cout << "C = " << bestTransfer2.C << std::endl;
    std::cout << "Ho = " << bestTransfer2.Ho << std::endl;
    std::cout << "R1 = " << bestTransfer2.R1 << std::endl;
    std::cout << "R2 = " << bestTransfer2.R2 << std::endl;
    std::cout << "R3 = " << bestTransfer2.R3 << std::endl;
    std::cout << "Wo Error =  = " << bestTransfer2.Woerror << std::endl;
    std::cout << "Q Error =  = " << bestTransfer2.Qerror << std::endl;

    return 0;
}
