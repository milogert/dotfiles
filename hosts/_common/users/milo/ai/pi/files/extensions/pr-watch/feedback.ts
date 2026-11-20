/**
 * Represents one status check returned by GitHub.
 */
export type Check = {
  name?: string;
  context?: string;
  conclusion?: string;
  state?: string;
  detailsUrl?: string;
  targetUrl?: string;
  completedAt?: string;
};

/**
 * Represents one issue or review comment returned by GitHub.
 */
export type Comment = {
  html_url: string;
  updated_at?: string;
  created_at: string;
  body?: string;
  user?: { login: string };
  path?: string;
  line?: number;
};

/**
 * Represents one pull-request review returned by GitHub.
 */
export type Review = {
  id: number;
  state: string;
  submitted_at: string;
  html_url: string;
  body?: string;
  user?: { login: string };
};

/**
 * Stores a deduplication key and the safe payload sent to the agent.
 */
type Feedback = {
  key: string;
  kind: string;
  data: unknown;
};

const FAILURE_STATES = [
  "FAILURE",
  "ERROR",
  "TIMED_OUT",
  "CANCELLED",
  "ACTION_REQUIRED",
  "STARTUP_FAILURE",
];

const CHANGE_STATES = ["CHANGES_REQUESTED", "COMMENTED"];

/**
 * Selects failed checks and post-push comments or reviews for delivery.
 */
export function collectFeedback(
  checks: Check[],
  comments: Comment[],
  reviews: Review[],
  pushedAt: number,
): Feedback[] {
  const feedback: Feedback[] = [];

  for (const check of checks) {
    if (FAILURE_STATES.includes(check.conclusion || check.state || "")) {
      feedback.push({
        key: `check:${check.detailsUrl || check.targetUrl}:${check.name || check.context}:${check.completedAt}:${check.conclusion || check.state}`,
        kind: "CI failure",
        data: check,
      });
    }
  }

  for (const comment of comments) {
    if (Date.parse(comment.updated_at || comment.created_at) >= pushedAt) {
      feedback.push({
        key: `comment:${comment.html_url}:${comment.updated_at}`,
        kind: "comment",
        data: {
          url: comment.html_url,
          author: comment.user?.login,
          path: comment.path,
          line: comment.line,
          body: comment.body?.slice(0, 4000),
        },
      });
    }
  }

  for (const review of reviews) {
    if (CHANGE_STATES.includes(review.state) && Date.parse(review.submitted_at) >= pushedAt) {
      feedback.push({
        key: `review:${review.id}:${review.submitted_at}:${review.state}`,
        kind: "review",
        data: {
          url: review.html_url,
          author: review.user?.login,
          state: review.state,
          body: review.body?.slice(0, 4000),
        },
      });
    }
  }

  return feedback;
}
