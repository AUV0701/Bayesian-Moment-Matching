clear all
numData = 30000;
%%% Check the running thing of the code with the initial parameters - when
%%% it gives error?

%%% DEFINE NAIVE BAYES MODEL WITH EXACT PARAMETERS %%%
theta_0 = 0.35;     % P(C=0)
phi_0 = 0.21;       % P(F=0 | C = 0)
lambda_0 = 0.53;    % P(F=0 | C = 1)
t0 = 0;
t1 = 0;
%%% GENERATE DATA FOR NAIVE BAYES %%%
p1 = theta_0*phi_0 + (1-theta_0)*lambda_0;
p2 = theta_0*(1-phi_0) + (1-theta_0)*(1-lambda_0);

t = rand(numData,1);

for i = 1 : length(t)
    if t(i) < p1
        data(i,1) = 0;
    else
        data(i,1) = 1;
    end
end

loglikelihoodData = calculateloglik(theta_0, phi_0, lambda_0, data);


alpha = randi(5,1,2);
beta = randi(7,1,2);
gamma = randi(9,1,2);

alphaM = randi(5,1,2);
betaM = randi(7,1,2);
gammaM = randi(9,1,2);

alphaS = alphaM;
betaS = betaM;
gammaS = gammaM;

loglikelihoodMartingale(1:length(data)) = 0;
loglikelihoodSufficient(1:length(data)) = 0;
loglikelihoodHybrid(1:length(data)) = 0;
for j = 1 : length(data)
%     if (j<100)
% %         disp('BMM using sufficient moments')
%         [alpha, beta, gamma] = momentMatchingSufficient(alpha, beta, gamma, data(j));
%     else
%         [alpha, beta, gamma] = momentMatchingMartingale(alpha, beta, gamma, data(j));
%     end
    [alphaM, betaM, gammaM] = momentMatchingMartingale(alphaM, betaM, gammaM, data(j));
    [alphaS, betaS, gammaS] = momentMatchingSufficient(alphaS, betaS, gammaS, data(j));
    loglikelihoodMartingale(j) = calculateloglik(alphaM(1)/sum(alphaM), betaM(1)/sum(betaM), gammaM(1)/sum(gammaM), data);
    loglikelihoodSufficient(j) = calculateloglik(alphaS(1)/sum(alphaS), betaS(1)/sum(betaS), gammaS(1)/sum(gammaS), data);
    loglikelihoodHybrid(j) = calculateloglik(alpha(1)/sum(alpha), beta(1)/sum(beta), gamma(1)/sum(gamma), data);
end

plot(1:length(data), loglikelihoodMartingale, '--r','Linewidth', 2);
% plot(1:length(data), loglikelihoodHybrid, '-r','Linewidth', 2);
hold on; plot(1:length(data), loglikelihoodSufficient, 'b','Linewidth', 2)
hold on; plot(1:length(data), repmat(loglikelihoodData,length(data), 1), '-k', 'LineWidth',2)
xlabel('Number of Observations')
ylabel('log-likelihood')
legend('martingale log-likelihood','normal log-likelihood','data log-likelihood')