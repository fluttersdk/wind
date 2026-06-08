import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class BlogSectionExamplePage extends StatelessWidget {
  const BlogSectionExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: WDiv(
        className: "bg-white py-24 sm:py-32 dark:bg-gray-900",
        child: WDiv(
          className: "mx-auto max-w-7xl px-6 lg:px-8",
          children: [
            // Header Section
            WDiv(
              className: "mx-auto max-w-2xl lg:mx-0",
              children: [
                WText(
                  "From the blog",
                  className:
                      "text-4xl font-semibold text-gray-900 sm:text-5xl dark:text-white",
                ),
                WText(
                  "Learn how to grow your business with our expert advice.",
                  className: "mt-2 text-lg text-gray-600 dark:text-gray-300",
                ),
              ],
            ),
            // Blog Posts Grid
            WDiv(
              className:
                  "mx-auto mt-10 grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 border-t border-gray-200 pt-10 sm:mt-16 sm:pt-16 lg:mx-0 lg:max-w-none lg:grid-cols-3 dark:border-gray-700",
              children: [
                _buildArticle(
                  date: "Mar 16, 2020",
                  category: "Marketing",
                  title: "Boost your conversion rate",
                  description:
                      "Small copy tweaks on your pricing page can lift sign-ups more than a full redesign. We break down three A/B tests that each moved conversion by double digits, and the reasoning behind every change.",
                  authorName: "Michael Foster",
                  authorRole: "Co-Founder / CTO",
                  authorImage:
                      "https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
                ),
                _buildArticle(
                  date: "Mar 10, 2020",
                  category: "Sales",
                  title: "How to use search engine optimization to drive sales",
                  description:
                      "Organic search still drives the cheapest qualified leads. Here is a practical SEO checklist your sales team can hand to marketing, from keyword intent to internal linking.",
                  authorName: "Lindsay Walton",
                  authorRole: "Front-end Developer",
                  authorImage:
                      "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
                ),
                _buildArticle(
                  date: "Feb 12, 2020",
                  category: "Business",
                  title: "Improve your customer experience",
                  description:
                      "Support tickets are a goldmine for product insight. Learn how we route, tag, and review customer feedback so the most common pain points reach the roadmap within a single sprint.",
                  authorName: "Tom Cook",
                  authorRole: "Director of Product",
                  authorImage:
                      "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticle({
    required String date,
    required String category,
    required String title,
    required String description,
    required String authorName,
    required String authorRole,
    required String authorImage,
  }) {
    return WDiv(
      className: "flex flex-col items-start justify-between max-w-xl",
      children: [
        // Date and Category
        WDiv(
          className: "flex items-center gap-x-4 text-xs",
          children: [
            WText(date, className: "text-gray-500 dark:text-gray-400"),
            WAnchor(
              onTap: () {},
              child: WDiv(
                className:
                    "rounded-full bg-gray-50 px-3 py-1 font-medium text-gray-600 hover:bg-gray-100 dark:bg-gray-800 dark:text-gray-300 dark:hover:bg-gray-700 duration-200",
                child: WText(category),
              ),
            ),
          ],
        ),
        // Title and Description
        WAnchor(
          onTap: () {},
          child: WDiv(
            className: "flex-grow mt-3",
            children: [
              WText(
                title,
                className:
                    "text-lg font-semibold text-gray-900 hover:text-gray-600 dark:text-white dark:hover:text-gray-300 duration-200",
              ),
              WText(
                description,
                className:
                    "mt-5 line-clamp-3 text-sm text-gray-600 dark:text-gray-400",
              ),
            ],
          ),
        ),
        // Author Info
        WDiv(
          className: "mt-8 flex items-center gap-x-4",
          children: [
            WImage(
              src: authorImage,
              className:
                  "w-10 h-10 rounded-full bg-gray-50 dark:bg-gray-800 object-cover",
            ),
            WDiv(
              className: "text-sm",
              children: [
                WAnchor(
                  onTap: () {},
                  child: WText(
                    authorName,
                    className:
                        "font-semibold text-gray-900 hover:text-gray-600 dark:text-white dark:hover:text-gray-300 duration-200",
                  ),
                ),
                WText(
                  authorRole,
                  className: "text-gray-600 dark:text-gray-400",
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
