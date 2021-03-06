function subscribe(detID, varargin)
%subscribe Subscribe to lanearea detector variable.
%   subscribe(DETID) Subscribe to the LAST_STEP_VEHICLE_NUMBER value for
%   the maximum allowed interval.
%   subscribe(DETID,VARIDS) Subscribe to the values given in the cell 
%   array of strings VARIDS for the maximum allowed interval.
%   subscribe(...,BEGIN) Subscribe from the time BEGIN to the maximum 
%   allowed end time.
%   subscribe(...,END) Subscribe for the time interval defined by BEGIN and 
%   END.
%   A call to this function clears all previous subscription results.

%   Copyright 2016 Universidad Nacional de Colombia,
%   Politecnico Jaime Isaza Cadavid.
%   Authors: Andres Acosta, Jairo Espinosa, Jorge Espinosa.
%   $Id: subscribe.m 31 2016-09-28 15:16:56Z afacostag $

global laneareaSubscriptionResults
import traci.constants

% Parse the input
p = inputParser;
p.FunctionName = 'lanearea.subscribe';
p.addRequired('detID',@ischar)
p.addOptional('varIDs', {constants.LAST_STEP_VEHICLE_NUMBER}, @iscell)
p.addOptional('subscriptionBegin', 0, @(x)isnumeric(x) && length(x)==1)
p.addOptional('subscriptionEnd', 2^31-1, @(x)isnumeric(x) && length(x)==1)
p.parse(detID, varargin{:})
detID = p.Results.detID;
varIDs = p.Results.varIDs;
subscriptionBegin = p.Results.subscriptionBegin;
subscriptionEnd = p.Results.subscriptionEnd;

% Construct the subscription results object
if isempty(laneareaSubscriptionResults)
    laneareaSubscriptionResults = traci.SubscriptionResults(traci.RETURN_VALUE_FUNC.lanearea);
else
    laneareaSubscriptionResults.reset();
end

% Call the traci subscribe function
traci.subscribe(constants.CMD_SUBSCRIBE_LANEAREA_VARIABLE,...
    subscriptionBegin, subscriptionEnd, detID, varIDs)