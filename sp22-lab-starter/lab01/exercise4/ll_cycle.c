#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    node *fast_ptr = head, *slow_ptr = head;
    do {
        if (fast_ptr == NULL || fast_ptr->next == NULL) return 0;
        fast_ptr = fast_ptr->next->next;
        slow_ptr = slow_ptr->next;
    } while (fast_ptr != slow_ptr);
    return 1;
}
