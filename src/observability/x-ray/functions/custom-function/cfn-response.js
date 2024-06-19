// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0
import fetch from "node-fetch";

export const SUCCESS = "SUCCESS";
export const FAILED = "FAILED";

export const send = async function (
  event,
  context,
  responseStatus,
  responseData,
  physicalResourceId,
  noEcho
) {
  const responseBody = JSON.stringify({
    Status: responseStatus,
    Reason:
      "See the details in CloudWatch Log Stream: " + context.logStreamName,
    PhysicalResourceId: physicalResourceId || context.logStreamName,
    StackId: event.StackId,
    RequestId: event.RequestId,
    LogicalResourceId: event.LogicalResourceId,
    NoEcho: noEcho || false,
    Data: responseData,
  });

  console.log("Response body:\n", responseBody);
  const response = await fetch(event.ResponseURL, {
    method: "PUT",
    body: responseBody,
  });
  return response;
};
