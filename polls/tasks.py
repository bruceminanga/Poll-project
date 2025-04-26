from celery import shared_task
import time


@shared_task
def log_vote_task(choice_id, current_votes):
    # Simulate some work (e.g., logging, sending notification)
    time.sleep(2)  # Simulate 2 seconds of work
    print(f"Vote logged for choice ID {choice_id}. New vote count: {current_votes}")
    # In a real app, you might:
    # - Write a more detailed log entry to a file or logging service
    # - Send a notification (email, Slack)
    # - Update an analytics dashboard
    # - etc.
    return f"Vote logged successfully for choice {choice_id}"
